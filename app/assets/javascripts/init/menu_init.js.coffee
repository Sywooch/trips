#= require classes/loading_spin
#= require views/menu_view
#= require backbone-validation
$ ->
  spinner = new App.LoadingSpin($('#menu .days .tab-content')[0])
  spinner.start()

  Backbone.Validation.configure
    forceUpdate: true
  $.ajax
    url: "/menu/menus/products"
    type: "GET"
    dataType: "json"
    success: (data) ->
      App.collections.MenuProductCategoryCollection.reset data["product_categories"]
      App.collections.MenuProductCollection.reset data["products"]
      App.collections.MenuDishCategoryCollection.reset data["dish_categories"]
      App.collections.MenuDishCollection.reset data["dishes"]
      App.collections.MenuDishProductCollection.reset data["dish_products"]
      App.collections.MenuMealCollection.reset data["meals"]
      productsView = new App.views.MenuProductsView(
        el: "#product_list"
        categories: App.collections.MenuProductCategoryCollection
        products: App.collections.MenuProductCollection
      )
      dishesView = new App.views.MenuDishesView(
        el: "#dish_list"
        categories: App.collections.MenuDishCategoryCollection
        dishes: App.collections.MenuDishCollection
      )
      mealsView = new App.views.MenuMealsView(
        el: "#meal_list"
        meals: App.collections.MenuMealCollection
      )
      menuView = new App.views.MenuView(
        menu: JSON.parse($("#menu_item").html())
        days: JSON.parse($("#menu_days").html())
        entities: JSON.parse($("#menu_entities").html())
      )
      menuView.createDay() if menuView.days.length == 0

      menuProductsList = React.createFactory(MenuProductsList)
      ReactDOM.render(
        menuProductsList({ entities: menuView.entities }),
        document.getElementById("menu-products")
      )
      spinner.stop()

    context: this


