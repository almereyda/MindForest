﻿define([
  'services/logger',
  'services/app',
  'services/mind'
], function (logger, app, mind) {

	var vm = {
		//Properties
		app: app,

		connection: app.mind.currentConnection,
		node: app.mind.currentNode,

		//Lifecycle Events
		canActivate: canActivate,
		compositionComplete: compositionComplete

	};
	return vm;

	function canActivate() {
		return app.user.mayEdit();
	}

	function compositionComplete(view, parent) {
		//logger.log('Composition complete', 'dock', view);
		if (app.detailsVisible) {
			app.showDetails();
		}
	}

}); //define
