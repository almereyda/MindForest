//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MindForest.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Connection
    {
        public long FromId { get; set; }
        public long ToId { get; set; }
        public int Position { get; set; }
        public Nullable<bool> IsVisible { get; set; }
        public Nullable<bool> IsExpanded { get; set; }
        public string Style { get; set; }
        public string Color { get; set; }
        public string Width { get; set; }
        public string Hook { get; set; }
        public string ForeignId { get; set; }
        public string ForeignOrigin { get; set; }
        public System.DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime ModifiedAt { get; set; }
        public string ModifiedBy { get; set; }
        public long Id { get; set; }
        public string Class { get; set; }
    }
}
