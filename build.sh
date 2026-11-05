#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/netspeedindicator@subashghimire.info.np"

rm -f ../netspeedindicator@subashghimire.info.np.zip
zip -r ../netspeedindicator@subashghimire.info.np.zip *.js utils/*.js
zip ../netspeedindicator@subashghimire.info.np.zip metadata.json

