#!/usr/bin/env python

import sys

ANALYTICS = '''<!-- Quantcast Tag -->
<script type="text/javascript">
<!--//

var _qevents = _qevents || [];

(function() {
var elem = document.createElement('script');
elem.src = (document.location.protocol == "https:" ? "https://secure" : "http://edge") + ".quantserve.com/quant.js";
elem.async = true;
elem.type = "text/javascript";
var scpt = document.getElementsByTagName('script')[0];
scpt.parentNode.insertBefore(elem, scpt);
})();

_qevents.push({
qacct:"p-0bpH4thh8w_tE"
});
//-->

</script>

<noscript>
<div style="display:none;">
<img src="//pixel.quantserve.com/pixel/p-0bpH4thh8w_tE.gif" border="0" height="1" width="1" alt="Quantcast"/>
</div>
</noscript>
<!-- End Quantcast tag -->

<!-- Begin Google analytics -->
<script type="text/javascript">
<!--//
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");


document.write(unescape("%3Cscript src='" + gaJsHost + 
"google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
//-->


</script>
<script type="text/javascript">
<!--//
var pageTrackerCG = _gat._getTracker("UA-1156969-3");


pageTrackerCG._setAllowHash(false);
pageTrackerCG._setDetectFlash(true);
pageTrackerCG._setDetectTitle(true);
pageTrackerCG._setDomainName("none");
pageTrackerCG._setAllowLinker(true);
pageTrackerCG._initData();


pageTrackerCG._setVar("rating_55");
pageTrackerCG._trackPageview();

//-->
</script>
<!-- end google analytics -->'''


filename = sys.argv[1]

with open(filename, 'r') as f:
    contents = f.read().replace(ANALYTICS, '')

with open(filename, 'w') as f:
    f.write(contents)

