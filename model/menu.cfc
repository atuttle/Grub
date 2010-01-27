component hint="" output="false" persistent="true" accessors="true" {

	property name="MenuId" type="numeric" hint="unique id per menu" fieldtype="id" elementtype="integer" generator="identity";
	property name="UserId" fieldtype="many-to-one" cfc="user" fkcolumn="UserId" hint="FK to user entity";

	property name="Meals" type="array" hint="array of meals belonging to this menu"
				singularname="Meal" fieldtype="one-to-many" cfc="meal" fkcolumn="MenuId"
				inverse="true" cascade="all";

	public void function setUser(user User){
		arguments.User.addMenu(this);
		variables.UserId = arguments.User;
	}

}