﻿//#region Binding Providers

(function () {

	//Catch binding exceptions using a custom binding provider
	//see: http://www.knockmeout.net/2013/06/knockout-debugging-strategies-plugin.html
	var existing = ko.bindingProvider.instance;

	ko.bindingProvider.instance = {
		nodeHasBindings: existing.nodeHasBindings,
		getBindings: function(node, bindingContext) {
			var bindings;
			try {
				bindings = existing.getBindings(node, bindingContext);
			}
			catch (ex) {
				if (window.console && console.log) {
					console.log("KO binding error: " + ex.message, node, bindingContext);
				}
			}
			return bindings;
		}
	};

})();

//#endregion Binding Providers


//#region general ko.bindingHandlers

//fadeVisible: visible usung fadeIn/fadeOut effects
ko.bindingHandlers.fadeVisible = {
	init: function (element, valueAccessor) {
		// Initially set the element to be instantly visible/hidden depending on the value
		var value = valueAccessor();
		$(element).toggle(ko.utils.unwrapObservable(value)); // Use "unwrapObservable" so we can handle values that may or may not be observable
	},
	update: function (element, valueAccessor) {
		// Whenever the value subsequently changes, slowly fade the element in or out
		var value = valueAccessor();
		ko.utils.unwrapObservable(value) ? $(element).fadeIn() : $(element).fadeOut();
	}
};

//class: like css binding but gets the classname from binding (multiple classnames seperated by blank are possible)
ko.bindingHandlers.class = {
	update: function (element, valueAccessor) {
		if (element['__ko__previousClassValue__']) {
			$(element).removeClass(element['__ko__previousClassValue__']);
		}
		var value = ko.utils.unwrapObservable(valueAccessor());
		$(element).addClass(value);
		element['__ko__previousClassValue__'] = value;
	}
};

//textDate: formatted DateTime binding using moment.js and the moment.fromPT extension
ko.bindingHandlers.textDate = {
	init: function (element, valueAccessor, allBindingsAccessor) {
		var value = valueAccessor();
		var allBindings = allBindingsAccessor();
		var format = allBindings.format || 'DD.MM.YYYY HH:mm';
		$(element).change(function (event) {
			var text = $(this).val();
			try {
				var m = moment(text, format);
				var val = value();
				val.setHours(m.hour());
				val.setMinutes(m.minute());
				value(val);
			}
			catch (e) { }
		});
	},
	update: function (element, valueAccessor, allBindingsAccessor, viewModel) {
		var value = ko.utils.unwrapObservable(valueAccessor());
		var allBindings = allBindingsAccessor();
		//Options
		var attributeName = allBindings.bindTo || 'text';
		var format = allBindings.format || 'DD.MM.YYYY HH:mm';
		//parse Date
		var date = value === null
						 ? null
						 : value.toString().substring(0, 2) === 'PT'
						 ? moment.fromPT(value)
						 : moment(value);
		if (date && date.isValid) {
			//format
			var dateString = date.format(format);
			//var dateString = date.calendar();
			if (attributeName === 'text') {
				$(element).text(dateString);
			}
			else {
				$(element).attr(attributeName, dateString);
			}
		}
		else {
			//todo trigger ko.validation
			if (attributeName === 'text') {
				$(element).text('');
			}
			else {
				$(element).attr(attributeName, null);
			}
		}
	}
};

//select2: dropdown for multiselect
ko.bindingHandlers.select2 = {
	init: function (element, valueAccessor, allBindingsAccessor) {
		var obj = valueAccessor(),
			allBindings = allBindingsAccessor(),
			lookupKey = allBindings.lookupKey;
		$(element).select2(obj);
		if (lookupKey) {
			var value = ko.utils.unwrapObservable(allBindings.value);
			$(element).select2('data', ko.utils.arrayFirst(obj.data.results, function (item) {
				return item[lookupKey] === value;
			}));
		}

		ko.utils.domNodeDisposal.addDisposeCallback(element, function () {
			$(element).select2('destroy');
		});
	},
	update: function (element) {
		$(element).trigger('change');
	}
};

//#endregion general ko.bindingHandlers


//#region App specific ko.bindingHandlers

//databound connection lines used in mm
ko.bindingHandlers.plumb = {
    init: function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {

        try {

            var options = valueAccessor();
            //console.log("Begin------------init------");
            //console.log({ element: element, valueAccessor: valueAccessor(), allBindingsAccessor: allBindingsAccessor(), viewModel: viewModel, bindingContext: bindingContext });

            if (viewModel.Id() === 1 && !viewModel.isExpanded) {
                //console.log("--> if(viewModel.Id() == 1 && !viewModel.isExpanded) = TRUE , viewModel = ");
                //console.log({ viewModel: viewModel });

                for(var i = 0; i < viewModel.ConnectionsTo().length; i++) {
                    var c = viewModel.ConnectionsTo()[i];

                    //console.log("--> subscribing changes on c" + c.Id());

                    var subscription = c.isExpanded.subscribe(function (newValue) {
                        //console.log("--> subscription calles c" + c.Id() + " with value " + newValue);
                        ko.bindingHandlers.plumb.update(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext);
                        //this.$root.plumb.repaintEverything(); // Alternative ^^
                    }, bindingContext);
                }
            }

            if (viewModel.isExpanded) { // because root node has no such property
                //    var c = viewModel;
                for (var i = 0; i < viewModel.ChildConnections().length; i++) {

                    var c = viewModel.ChildConnections()[i];

                    //console.log("--> subscribing changes on c" + c.Id());
                    //subscribe expanding and collapsing nodes
                    var subscription = c.isExpanded.subscribe(function (newValue) {
                    	try {
							ko.bindingHandlers.plumb.update(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext);							//setTimeout(this.$root.plumb.repaintEverything(),2000); // Alternative ^^
                    		this.$root.plumb.repaintEverything();
                    	} catch (e) {
                    		console.warn("[plumb-binding] Catch von subscription !!! -- " + e.message);
                    	}

                    }, bindingContext);

                    //unsubscribe on dsposal
                    ko.utils.domNodeDisposal.addDisposeCallback(element, function (p1, p2, p3, p4) {
                    	try {
							//console.log("--> disposing subscription");
							//console.log({ p1: p1, p2: p2, p3: p3, p4: p4});
							//bindingContext.$root.plumb.repaintEverything();
							subscription.dispose();
                    	} catch (e) {
                    		console.warn("[plumb-binding] Catch von disposing !!! -- " + err.message);
                    	}

                    });
                } // end for (viewModel.ChildConnections)
            } // end if (viewModel.isExpanded)

            /* Bestimen der Pos eines Divs
            // Findet die absolute x Position eines Elementes raus
            function getAbsoluteX (elm) {
               var x = 0;
               if (elm && typeof elm.offsetParent != "undefined") {
                 while (elm && typeof elm.offsetLeft == "number") {
                   x += elm.offsetLeft;
                   elm = elm.offsetParent;
                 }
               }
               return x;
            }
    
    
            // Findet die absolute y Position eines Elementes raus
            function getAbsoluteY(elm){
               var y = 0;
               if (elm && typeof elm.offsetParent != "undefined") {
                 while (elm && typeof elm.offsetTop == "number") {
                   y += elm.offsetTop;
                   elm = elm.offsetParent;
                 }
               }
               return y;
            }
    
            // anwenden der Funktionen
            var elm = document.getElementById("divid");
            var x = getAbsoluteX(elm);
             */
            //console.log("end-------------!init------");

        }
        catch (err) {
            console.warn("[plumb-binding] Catch von init !!! -- " + err.message);
        }

	}, //init
    update: function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {

        try {

            //console.log("-----------------update------");
            var options = ko.utils.unwrapObservable(valueAccessor());
            //var plumb = $.data(element, 'plumb');
            var plumb = bindingContext.$root.plumb;
            var connections = options.data();

            //jsPlumb.doWhileSuspended(function () {

            //plumb.removeAll();
            if (connections.length) {
                var from = options.fromId || 'node-' + connections[0].FromId();
                var container = options.containerId || 'container-c' + connections[0].Id();
                for (var i = 0; i < connections.length; i++) {
                    var con = connections[i];
                    var to = options.toId || 'node-' + con.ToId();
                    //console.log('creating line:  ' + from + ' ---> ' + to + ' | on ' + container);
                    connections[i].line = plumb.connect({
                        source: from,
                        target: to,
                        container: container
                        //,overlays: [
                        //    ["Label", { label: con.Id() + '', id: "line-" + con.Id() }]
                        //]
                    });
                    //plumb.draggable(to);
                } //for
            } //if (connections.length)
            
            try {
                plumb.repaintEverything(); // TODO: optimize performenc

                // SET TIME OUT //
                //setTimeout(function () { plumb.repaintEverything(); }, 500);
                // not nessesery: delayed bindingHandler in mein.js
            }
            catch (err) { //hier taucht der "o is undefined" Error auf.
                console.warn("[plumb-binding] Catch von plumb.repaintEverything() in update -- " + err.message);
            }

        }
        catch (err) {
            console.warn("[plumb-binding] Catch von update !!! -- " + err.message);
        } // Dieser sollte das Error Problem mit "o not defined" forübergängig lösen (hat den fehler antscheinend egchatscht^^)

	} //update
}; //ko.bindingHandlers.plumbSortable

//#endregion App specific ko.bindingHandlers


//#region Global Extensions

//Extension for moment to understand MS DateTime (actually time only) format
moment.fromPT = function (time) {
	if (!time) return null;
	var h = 0, m = 0, s = 0;
	var parts = time.replace(/PT/, '');
	if (parts.indexOf("H") > -1) {
		parts = parts.split("H");
		h = parseInt(parts[0], 10);
		parts = parts[1];
	}
	if (parts.indexOf("M") > -1) {
		parts = parts.split("M");
		m = parseInt(parts[0], 10);
		parts = parts[1];
	}
	if (parts.indexOf("S") > -1) {
		parts = parts.split("S");
		s = parseInt(parts[0], 10);
	}
	return moment().year(0).month(0).date(0).hour(h).minute(m).second(s);
};

//#endregion Global Extensions