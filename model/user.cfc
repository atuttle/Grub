component hint="A User Object" output="false" persistent="true" accessors="true" {

	property name="UserId" type="numeric" fieldtype="id" elementtype="integer" generator="increment" generated="insert";
	property name="FName" type="string" hint="first name" length="50";
	property name="LName" type="string" hint="last name" length="50";
	property name="Email" type="string" hint="email address" length="255";
	property name="EmailVerified" type="boolean" hint="whether or not the email address has been verified" default="false" elementtype="boolean";
	property name="PasswordHash" type="string" hint="hashed password" length="32";

	property name="Menus" fieldtype="one-to-many" cfc="menu" fkcolumn="UserId" cascade="all" type="array" singularname="Menu" inverse="true";

}