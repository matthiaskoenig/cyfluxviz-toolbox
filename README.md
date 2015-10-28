# cyfluxviz-toolbox

<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&amp;hosted_button_id=RYHNRJFBMWD5N" title="Donate to this project using Paypal"><img src="https://img.shields.io/badge/paypal-donate-yellow.svg" alt="PayPal donate button" /></a>

**cyfluxviz-toolbox** is a collection of Matlab scripts and functions for the  generation of cyfluxviz files for visualization. **cyfluxviz-toolbox** supports COBRA output which can be directly converted 
into flux files for cyfluxviz.

**Status** : release  
**Documentation** : http://matthiaskoenig.github.io/cy2fluxviz/  
**Support & Forum** : https://groups.google.com/forum/#!forum/cysbml-cyfluxviz  
**Bug Tracker** : https://github.com/matthiaskoenig/cyfluxviz-toolbox/issues  

## License
* Source Code: [GPLv3](http://opensource.org/licenses/GPL-3.0)
* Documentation: [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/)

## Installation
**requirements**
- MATLAB
- COBRA toolbox
- SBML toolbox

Download the source code, extract and run in MATLAB in the source folder the  
`install_cyfluxfiz_toolbox`  
script. This will add the scripts of the toolbox to the MATLAB path.

Various examples are provided in the  
`./examples`  
subfolder with COBRA examples in  
`./examples/cobra`

To run the COBRA examples the COBRA Toolbox must be installed (for further information see http://opencobra.sourceforge.net/openCOBRA/Welcome.html)

For some features (mainly the conversion of C13 flux data to CyFluxViz formats) SBML support is needed and consequently the SBML Toolbox has to be installed. For further information see http://sbml.org/Software/SBMLToolbox)

## ChangeLog 
**v0.05** [2014-04-05]
- cleanup of installation script
- additional documentation & chlamydomonas example

**v0.04** [2013-08-30]
- support of COBRA subsystems. Generation of Cytoscape node attribute files from
	the COBRA model struct.

**v0.03** [2013-08-07]
- validation of fluxData struct implemented (helps the user to generate the right data format in Matlab)
- SBML identifier bug fixed (COBRA modifies SBML identifiers)
- Genome scale example added (E.coli)
- Better documentation of examples.
- JSON export added (alpha)

**v0.02** [2013-08-01]
- first implementation of the the file parsers & examples

