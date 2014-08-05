# Sliq

[![Gem Version](https://badge.fury.io/rb/sliq.png)](http://rubygems.org/gems/sliq) [![Build Status](https://secure.travis-ci.org/slim-template/sliq.png?branch=master)](http://travis-ci.org/slim-template/sliq) [![Dependency Status](https://gemnasium.com/slim-template/sliq.png?travis)](https://gemnasium.com/slim-template/sliq) [![Code Climate](https://codeclimate.com/github/slim-template/sliq.png)](https://codeclimate.com/github/slim-template/sliq) [![Gittip donate button](http://img.shields.io/gittip/bevry.png)](https://www.gittip.com/min4d/ "Donate weekly to this project using Gittip")
[![Flattr donate button](https://raw.github.com/balupton/flattr-buttons/master/badge-89x18.gif)](https://flattr.com/submit/auto?user_id=min4d&url=http%3A%2F%2Fsliq-lang.org%2F "Donate monthly to this project using Flattr")

Sliq integrates [Slim](http://slim-lang.com) with [Liquid](http://liquidmarkup.org/). This is pretty much experimental.

## Links

* Source: <http://github.com/slim-template/slim>
* Bugs:   <http://github.com/slim-template/sliq/issues>
* List:   <http://groups.google.com/group/slim-template>
* API documentation:
    * Latest Gem: <http://rubydoc.info/gems/sliq/frames>
    * GitHub master: <http://rubydoc.info/github/slim-template/sliq/master/frames>

## Try it yourself

You currently have to use the Tilt template class manually.

Syntax example:

~~~
% for product in products
 li
   h2 {{product.title}}
   | Only {{ product.price | format_as_money }}
   p {{ product.description | prettyprint | truncate: 200  }}
~~~
