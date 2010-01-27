component output="false" persistent="true" accessors="true" {

	property name="MenuId" type="numeric" fieldtype="id" elementtype="integer" generator="increment" generated="insert";
	property name="MenuName" type="string";

	//relationship properties (aka foreign keys)
	property name="User" fieldtype="many-to-one" cfc="user" fkcolumn="UserId";
	property name="Meals" fieldtype="one-to-many" cfc="meal" fkcolumn="MenuId" cascade="all" type="array" singularname="Meal" inverse="true";

	//customization
	public void function setUser(user thisUser){
		arguments.thisUser.addMenu(this);
		variables.User = arguments.thisUser;
	}

}