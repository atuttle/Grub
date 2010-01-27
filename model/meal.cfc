component hint="meal data" output="false" persistent="true" accessors="true" {

	property name="MealId" type="numeric" hint="unique id per meal" fieldtype="id" elementtype="integer" generator="increment" generated="insert";
	property name="MealName" type="string";
	property name="MealType" type="string";
	property name="MaxFrequency" type="numeric";

	property name="Menu" fieldtype="many-to-one" cfc="menu" fkcolumn="MenuId";

	public void function setMenu(menu Menu) {
		arguments.Menu.addMeal(this);
		variables.Menu = arguments.Menu;
	}

}