import * as highlights from './src/it_way/podcasts/highlights'
import * as terminalWriter from './src/terminal_writer/index'

var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);
