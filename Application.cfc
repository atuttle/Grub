component displayname="Application" extends="framework" {

	this.name = "grub";
	this.sessionmanagement = true;
	this.sessiontimeout = createTimespan(0,0,10,0);
	this.setclientcookies = true;
	this.scriptprotect = false;
	this.ormenabled = true;
	this.ormsettings = { cfclocation = 'model' , dbCreate = "dropCreate" , logSQL = true , dialect = 'MySQLwithInnoDB' };
	this.datasource = "grub";
	this.mappings = {};

	//application mode (environment)
	variables.mode = getApplicationMode();

	variables.framework = {
		home = "default.home",
		defaultSection = "default",
		reloadApplicationOnEveryRequest = ((variables.mode == "dev") ? true : false)
	};

	boolean function setupApplication() output="false" {
		switch(variables.mode){
			case "dev":
				this.ormsettings.dbCreate = 'dropCreate';
				break;
			case "prod":
				break;
		}

		//make application mode globally accessable
		application.mode = variables.mode;

		//password salt used to securely hash passwords
		application.passwordSalt = 'GG!90$%';

		//run db population step (add initial data)
		//this could be done with a sql script, but I like CF-ORM! :)
		initializeData();

		return true;
	}

	void function setupSession() {}

	void function setupRequest() {}

	//=============================================================
	//=============================================================
	// CUSTOM FUNCTIONALITY
	//=============================================================
	//=============================================================

	private void function initializeData() output="false" hint="Run once per db create. Adds initial data. (Eg. Administrator account)" {

		ormReload();
		import model.*;

		//create admin account
		var admin = new user();
		admin.setfname('Administrator');
		admin.setlname('Administrator');
		admin.setemail('adam@fusiongrokker.com');
		admin.setemailVerified(true);
		admin.setpasswordHash( hashPassword('test') );

		//I has a menu
		var menu = new menu();
		menu.setMenuName('default');
		menu.setUser(admin);
		//admin.addmenu(menu);

		EntitySave(admin);

writeDump(admin);
abort;

/*
		//we eat like Ali McBeal
		var meal = new model.meal();
		meal.setMealName('Chicken Alfredo');
		meal.setMealType('Chicken,Pasta');
		meal.setMaxFrequency(2);
		meal.setMenu(menu);

		meal = new model.meal();
		meal.setMealName('Hamburgers');
		meal.setMealType('Beef');
		meal.setMaxFrequency(4);
		EntitySave(meal);
		menu.addMeal(meal);

		meal = new model.meal();
		meal.setMealName('Spaghetti');
		meal.setMealType('Pasta');
		meal.setMaxFrequency(2);
		EntitySave(meal);
		menu.addMeal(meal);

		//save menu and cascade save meals
		EntitySave(menu);
*/

	}

	private string function hashPassword(required string strPassIn) output="false" {
		return hash( application.passwordSalt & arguments.strPassIn );
	}

	private string function getApplicationMode() output="false" hint="determines which environment the application is running on" {
		switch(cgi.http_host){
			case "www.grub.dev":
			case "grub.dev":
				return "dev";
				break;
			default:
				return "prod";
		}
	}

}