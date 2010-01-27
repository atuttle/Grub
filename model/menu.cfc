component output="false" persistent="true" accessors="true" {

	property name="MenuId" type="numeric" hint="unique id per menu" fieldtype="id" elementtype="integer" generator="increment" generated="insert";
	property name="MenuName" type="string";

/*
	property name="Meals" type="array" hint="array of meals belonging to this menu"
				singularname="Meal" fieldtype="one-to-many" cfc="meal" fkcolumn="MenuId"
				inverse="true" cascade="all";
*/

	property name="User" fieldtype="many-to-one" cfc="user" fkcolumn="UserId";

	public void function setUser(user thisUser){
		arguments.thisUser.addMenu(this);
		variables.User = arguments.thisUser;
	}

}