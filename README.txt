###############################################################################
CyFluxVizToolbox
###############################################################################
CyFluxVizToolbox is a collection of Matlab scripts and functions for the 
generation of CyFluxViz files for visualization.
CyFluxVizToolbox supports COBRA output which can be directly converted 
into flux files for CyFluxViz.

	author: Matthias König
	affiliation: Charite Berlin
	contact: matthias.koenig@charite.de
	data: 2013-08-06
	Copyright © Matthias König 2013 All Rights Reserved.

Please cite:
	Matthias König and Hermann-Georg Holzhütter
	FluxViz - Cytoscape Plug-in for Vizualisation of Flux Distributions in 
	Networks
	Genome Informatics 2010, Vol.24, p.96-103
	http://www.ncbi.nlm.nih.gov/pubmed?term=22081592

###############################################################################
    This file is part of CyFluxVizToolbox.

    CyFluxVizToolbox is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    CyFluxVizToolbox is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with CyFluxVizToolbox.  If not, see <http://www.gnu.org/licenses/>.


###############################################################################
	Installation
###############################################################################
From MATLAB, run
  initCyFluxVizToolbox

Usage examples are provided in the
	./examples
subfolder.

For COBRA support the COBRA Toolbox has to be installed (for further information
see http://opencobra.sourceforge.net/openCOBRA/Welcome.html)

For some features (mainly the conversion of C13 flux data to CyFluxViz formats)
SBML support is needed and consequently the SBML Toolbox has to be installed.
For further information see http://sbml.org/Software/SBMLToolbox)

###############################################################################
	Features & Bug Fixes
###############################################################################
> 1. at present CySBML tab names reactions and species using the COBRA's
> column 'metabolite/rxn description', names that sometimes are long. 
> Would it be possible to use 'Rxn name' (or metabolite name) both for
> CySBML tab and for naming nodes and edges in the graph?
I wrote this on the list of things to do. 
CySBML only uses the information stored in the SBML, whereas COBRA performs some modifications to the identifiers and names from the SBML, mainly clearing them up a bit. The best solution is probably to generate a modified SBML file which already incorporates the COBRA modifications and thereby is automatically used in CySBML. But this should be not too complicated. 
I wrote it on the list of upcoming features in CyFluxVizToolbox.

> 2. it would be useful to have the information in COBRA's 'Subsystem '
> available in 'Subnetwork', so one can reduce the network based on the
> function (or anything custom) assigned during model development. In my
> model eg TCA reactions are labelled under the 'Subsytem' tag.
I do not know exactly what the Subsystem is. If you send some example file in Matlab which accesses this information I could incorporate this in the filtering of the Network in CyFluxViz. 
For instance if there is a clear definition of reactions belonging to the subsystem TCA this information could be used to filter the visualization. 
If you can show me how to access this information I can show you how to use it to create subnetworks. 


###############################################################################
	ChangeLog 
###############################################################################
v.0.04 [2013-08-30]
- support of COBRA subsystems. Generation of Cytoscape node attribute files from
	the COBRA model struct.

v.0.03 [2013-08-07]
- validation of fluxData struct implemented (helps the user to generate
    the right data format in Matlab)
- SBML identifier bug fixed (COBRA modifies SBML identifiers)
- Genome scale example added (E.coli)
- Better documentation of examples.
- JSON export added (alpha)

v0.02 [2013-08-01]
- first implementation of the the file parsers & examples


