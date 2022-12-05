#!/bin/sh
# Configure 'waybar' CSS colors

cat << EOF > "${0%.*}"
@define-color COLOR_0   #${COLOR_0};
@define-color COLOR_1   #${COLOR_1};
@define-color COLOR_2   #${COLOR_2};
@define-color COLOR_3   #${COLOR_3};
@define-color COLOR_4   #${COLOR_4};
@define-color COLOR_5   #${COLOR_5};
@define-color COLOR_6   #${COLOR_6};
@define-color COLOR_7   #${COLOR_7};
@define-color COLOR_8   #${COLOR_8};
@define-color COLOR_9   #${COLOR_9};
@define-color COLOR_10  #${COLOR_10};
@define-color COLOR_11  #${COLOR_11};
@define-color COLOR_12  #${COLOR_12};
@define-color COLOR_13  #${COLOR_13};
@define-color COLOR_14  #${COLOR_14};
@define-color COLOR_15  #${COLOR_15};
EOF
