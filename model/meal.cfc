component output="false" persistent="true" accessors="true" {

	property name="MealId" type="numeric" fieldtype="id" elementtype="integer" generator="increment" generated="insert";
	property name="MealName" type="string";
	property name="MealType" type="string";
	property name="MaxFrequency" type="numeric";

	//relationship properties (aka foreign keys)
	property name="Menu" fieldtype="many-to-one" cfc="menu" fkcolumn="MenuId";

	//customization
	public void function setMenu(menu thisMenu) {
		arguments.thisMenu.addMeal(this);
		variables.Menu = arguments.thisMenu;
	}

}