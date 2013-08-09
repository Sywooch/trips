//= require collections/menu_day_collection
//= require collections/menu_day_entity_collection
//= require models/menu_day_entity_model

_.namespace("App.views");

(function() {
    App.views.MenuDayView = Backbone.View.extend({
        events: {
            'click button.close' : 'removeDay',
            'click .icon-remove' : 'removeEntity'
        },

        initialize: function (options) {
            this.model = options.model;
            this.render();
            this.bindEvents();
            this.entities = App.collections.MenuDayEntityCollection;
        },

        render: function () {
            this.$el.addClass('day');
            this.$el.html($(JST["templates/food/day"]({
                num: this.model.get('num')
            })));

            this.$el.droppable({
                drop: $.proxy(this.onEntityDrop, this)
            });
        },


        bindEvents : function () {
            this.model.on('change', $.proxy(function () {
                this.$el.find('.num').text(this.model.get('num'));
            }, this));
        },

        removeDay : function (e) {
            var num = this.model.get('num');
            App.collections.MenuDayCollection.remove(this.model);
            App.collections.MenuDayCollection.each(function (day) {
                if (day.get('num') > num) {
                    day.set('num', day.get('num') - 1);
                }
            });
            this.$el.remove();
        },

        onEntityDrop : function (event, ui) {
            $this = $(event.target);
            this.$el.find('.noitems').hide();
            
            var entity = new App.models.MenuDayEntityModel({
                entity_id : ui.draggable.data('id'),
                entity_type : ui.draggable.data('type'),
                day_id : this.model.cid
            });
            if ($this.is('.entity')) {
                var parent_id = $this.attr('id').split('_')[1];
                entity.set('parent_id', parent_id);
            }
            this.entities.add(entity);
            this.renderEntity(entity);
        },

        renderEntity : function (entity) {
            var entityEl = $("<div></div>");
            $('<i class="icon-remove"></i>').appendTo(entityEl);
            $('<span class="entity-name"></span>').text(entity.getName()).appendTo(entityEl);
            entityEl.attr('id', 'entity_' + entity.id)
                    .addClass('entity')
                    .addClass('entity-' + entity.get('entity_type'));
            if (entity.get('parent_id')) {
                entityEl.appendTo(this.$el.find('#entity_' + entity.get('parent_id')));
            } else {
                entityEl.appendTo(this.$el.find('.body'));
            }

            if (entity.get('entity_type') != 'prod') {
                entityEl.droppable({
                    greedy: true,
                    accept: entity.get('entity_type') == 'meal' ? ".product, .dish" : '.product',
                    activeClass: "ui-state-hover",
                    hoverClass: "ui-state-active",
                    drop : $.proxy(this.onEntityDrop, this)
                });
            }
            return entityEl;
        },

        removeEntity : function (event) {
            var entityEl = $(event.target).closest('.entity');
            var id = entityEl.attr('id').split('_')[1];
            var entity = this.entities.get(id);
            this.entities.remove(entity);
            entityEl.remove();
        }
    });
})();