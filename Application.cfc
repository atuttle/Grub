component displayname="Application" extends="framework" {

	this.name = "grub";
	this.sessionmanagement = true;
	this.sessiontimeout = createTimespan(0,0,10,0);
	this.setclientcookies = true;
	this.scriptprotect = false;
	this.ormenabled = true;
	this.ormsettings = { cfclocation = 'model' , dbCreate = "update" , logSQL = true , dialect = 'MySQLwithInnoDB' };
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

		application.mode = variables.mode;		//make application mode globally accessable
		application.passwordSalt = 'GG!90$%';	//password salt used to securely hash passwords

		switch(application.mode){
			case "dev":
				//recreate database on every request
				this.ormsettings.dbCreate = 'dropCreate';
				//never show friendly error page on dev
				structDelete(variables.framework, "error");
				break;
			case "stage":
				//update db schema as needed
				this.ormsettings.dbCreate = 'update';
				//show error pages
				variables.framework.error = 'error.show';
				break;
			case "prod":
				//update db schema as needed
				this.ormsettings.dbCreate = 'update';
				//show error pages
				variables.framework.error = 'error.show';
				break;
		}

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
		var defaultMenu = new menu();
		defaultMenu.setMenuName('default');
		defaultMenu.setUser(admin);

		var menu = new menu();
		menu.setMenuName('menu2');
		menu.setUser(admin);

		//we eat like Ali McBeal
		var meal = new meal();
		meal.setMealName('Chicken Alfredo');
		meal.setMealType('Chicken,Pasta');
		meal.setMaxFrequency(2);
		meal.setMenu(defaultMenu);

		meal = new model.meal();
		meal.setMealName('Hamburgers');
		meal.setMealType('Beef');
		meal.setMaxFrequency(4);
		meal.setMenu(defaultMenu);

		meal = new model.meal();
		meal.setMealName('Spaghetti');
		meal.setMealType('Pasta');
		meal.setMaxFrequency(2);
		meal.setMenu(defaultMenu);

		//save and cascade data
		EntitySave(admin);
		ormFlush();
	}

	private string function hashPassword(required string strPassIn) output="false" {
		return hash( application.passwordSalt & arguments.strPassIn );
	}

	private string function getApplicationMode() output="false" hint="determines which environment the application is running on" {
		switch(cgi.http_host){
			case "www.grub.dev":
			case "grub.dev":
				return "dev";
			case "stage.grublicio.us":
				return "stage";
			case "grublicio.us":
				return "prod";
			default:
				return "prod";
		}
	}

}