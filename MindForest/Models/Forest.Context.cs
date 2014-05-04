﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Data.Entity.Core.Objects.DataClasses;
    using System.Data.Entity.Infrastructure;
    using System.Linq;
    
    public partial class ForestEntities : DbContext
    {
        public ForestEntities()
            : base("name=ForestEntities")
        {
    		        this.Configuration.LazyLoadingEnabled = false;
        }
    		public ForestEntities(string ConnectionName)
            : base("name=" + ConnectionName)
        {
            this.Configuration.LazyLoadingEnabled = false;
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public DbSet<Node> Nodes { get; set; }
        public DbSet<Connection> Connections { get; set; }
        public DbSet<Membership> Memberships { get; set; }
        public DbSet<OAuthMembership> OAuthMemberships { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<UserProfile> UserProfiles { get; set; }
        public DbSet<Permission> Permissions { get; set; }
        public DbSet<NodeText> NodeTexts { get; set; }
    
        [EdmFunction("ForestEntities", "GetNeighbourConnections")]
        public virtual IQueryable<Connection> GetNeighbourConnections(Nullable<int> nodeId, string user, Nullable<int> levels, Nullable<int> skipLevels, string lang)
        {
            var nodeIdParameter = nodeId.HasValue ?
                new ObjectParameter("NodeId", nodeId) :
                new ObjectParameter("NodeId", typeof(int));
    
            var userParameter = user != null ?
                new ObjectParameter("User", user) :
                new ObjectParameter("User", typeof(string));
    
            var levelsParameter = levels.HasValue ?
                new ObjectParameter("Levels", levels) :
                new ObjectParameter("Levels", typeof(int));
    
            var skipLevelsParameter = skipLevels.HasValue ?
                new ObjectParameter("SkipLevels", skipLevels) :
                new ObjectParameter("SkipLevels", typeof(int));
    
            var langParameter = lang != null ?
                new ObjectParameter("Lang", lang) :
                new ObjectParameter("Lang", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.CreateQuery<Connection>("[ForestEntities].[GetNeighbourConnections](@NodeId, @User, @Levels, @SkipLevels, @Lang)", nodeIdParameter, userParameter, levelsParameter, skipLevelsParameter, langParameter);
        }
    
        [EdmFunction("ForestEntities", "GetChildConnections")]
        public virtual IQueryable<Connection> GetChildConnections(Nullable<int> nodeId, string user, Nullable<int> levels, Nullable<int> skipLevels, string lang)
        {
            var nodeIdParameter = nodeId.HasValue ?
                new ObjectParameter("NodeId", nodeId) :
                new ObjectParameter("NodeId", typeof(int));
    
            var userParameter = user != null ?
                new ObjectParameter("User", user) :
                new ObjectParameter("User", typeof(string));
    
            var levelsParameter = levels.HasValue ?
                new ObjectParameter("Levels", levels) :
                new ObjectParameter("Levels", typeof(int));
    
            var skipLevelsParameter = skipLevels.HasValue ?
                new ObjectParameter("SkipLevels", skipLevels) :
                new ObjectParameter("SkipLevels", typeof(int));
    
            var langParameter = lang != null ?
                new ObjectParameter("Lang", lang) :
                new ObjectParameter("Lang", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.CreateQuery<Connection>("[ForestEntities].[GetChildConnections](@NodeId, @User, @Levels, @SkipLevels, @Lang)", nodeIdParameter, userParameter, levelsParameter, skipLevelsParameter, langParameter);
        }
    
        [EdmFunction("ForestEntities", "GetParentConnections")]
        public virtual IQueryable<Connection> GetParentConnections(Nullable<int> nodeId, string user, Nullable<int> levels, Nullable<int> skipLevels, string lang)
        {
            var nodeIdParameter = nodeId.HasValue ?
                new ObjectParameter("NodeId", nodeId) :
                new ObjectParameter("NodeId", typeof(int));
    
            var userParameter = user != null ?
                new ObjectParameter("User", user) :
                new ObjectParameter("User", typeof(string));
    
            var levelsParameter = levels.HasValue ?
                new ObjectParameter("Levels", levels) :
                new ObjectParameter("Levels", typeof(int));
    
            var skipLevelsParameter = skipLevels.HasValue ?
                new ObjectParameter("SkipLevels", skipLevels) :
                new ObjectParameter("SkipLevels", typeof(int));
    
            var langParameter = lang != null ?
                new ObjectParameter("Lang", lang) :
                new ObjectParameter("Lang", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.CreateQuery<Connection>("[ForestEntities].[GetParentConnections](@NodeId, @User, @Levels, @SkipLevels, @Lang)", nodeIdParameter, userParameter, levelsParameter, skipLevelsParameter, langParameter);
        }
    
        [EdmFunction("ForestEntities", "GetRootNodes")]
        public virtual IQueryable<Node> GetRootNodes(string user, string lang)
        {
            var userParameter = user != null ?
                new ObjectParameter("User", user) :
                new ObjectParameter("User", typeof(string));
    
            var langParameter = lang != null ?
                new ObjectParameter("Lang", lang) :
                new ObjectParameter("Lang", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.CreateQuery<Node>("[ForestEntities].[GetRootNodes](@User, @Lang)", userParameter, langParameter);
        }
    
        [EdmFunction("ForestEntities", "GetNodes")]
        public virtual IQueryable<Node> GetNodes(string user, string lang)
        {
            var userParameter = user != null ?
                new ObjectParameter("User", user) :
                new ObjectParameter("User", typeof(string));
    
            var langParameter = lang != null ?
                new ObjectParameter("Lang", lang) :
                new ObjectParameter("Lang", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.CreateQuery<Node>("[ForestEntities].[GetNodes](@User, @Lang)", userParameter, langParameter);
        }
    }
}
