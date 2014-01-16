//Allow some postinstall configurations
console.log("*********************POSTINSTALL**********************");

//lets tweak the primus-live package if its present, to daisychain installation flags
var primusLiveTweaks = true;
if( primusLiveTweaks ) {
  console.log("Attempting primus-live updates");
  var path = require('path');
  var npmFlags = JSON.parse( process.env.npm_config_argv )["original"];
  try {
    var primus_package_path = path.join(__dirname,"../node_modules/primus-live/package.json");
    console.log("looking for:" + primus_package_path);
    var primus_package = require( primus_package_path );
    //console.log( primus_package );

    if( npmFlags[0].toLowerCase() == "install") {
      var skey = "npm_install_flags_" + process.platform
      var key = primus_package[skey]
      
      if (key === undefined ) {
        var installFlags = npmFlags.slice(1).join(" ");
        if( installFlags.replace(/\s/g,"") != "") {
          console.log("Setting primus-live 'npm' installation flags:" + installFlags);
          primus_package[skey] = installFlags
          var fs = require('fs');
          fs.writeFile(primus_package_path, JSON.stringify(primus_package,null,2), function(err){
                if(err) {
                    console.error("Error updating primus-live config:", err);
                    process.exit(1);
                }
            });

        }
      } else {
        //probably need a merge strategy here!!
        console.log("primus-live npm flag configuration already present - skipping");
      }
      
    }
  } catch (err) {
    //primus-live not present!!
    if(err.code == 'MODULE_NOT_FOUND') {
      console.log("primus-live does not seem to be present, so nothing to update!!");
    } else {
      throw err
    }
  }  

    
}

console.log("************************************************************");
