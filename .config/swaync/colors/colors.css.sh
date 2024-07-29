#!/bin/sh
# Configure 'waybar' CSS colors

cat << EOF > "${0%.*}"
@define-color COLOR_00  #${COLOR_00};
@define-color COLOR_01  #${COLOR_01};
@define-color COLOR_02  #${COLOR_02};
@define-color COLOR_03  #${COLOR_03};
@define-color COLOR_04  #${COLOR_04};
@define-color COLOR_05  #${COLOR_05};
@define-color COLOR_06  #${COLOR_06};
@define-color COLOR_07  #${COLOR_07};
@define-color COLOR_08  #${COLOR_08};
@define-color COLOR_09  #${COLOR_09};
@define-color COLOR_10  #${COLOR_10};
@define-color COLOR_11  #${COLOR_11};
@define-color COLOR_12  #${COLOR_12};
@define-color COLOR_13  #${COLOR_13};
@define-color COLOR_14  #${COLOR_14};
@define-color COLOR_15  #${COLOR_15};
@define-color COLOR_FG  #${COLOR_FG};
@define-color COLOR_BG  #${COLOR_BG};

/* @define-color cc-bg #${COLOR_BG}; */
/* @define-color noti-border-color rgba(255, 255, 255, 0.15); */
/* @define-color noti-bg #${COLOR_BG}; */
/* @define-color noti-bg-darker #${COLOR_00}; */
/* @define-color noti-bg-hover #${COLOR_BG}; */
/* @define-color noti-bg-focus rgba(27, 27, 27, 0.6); */
/* @define-color noti-close-bg rgba(255, 255, 255, 0.1); */
/* @define-color noti-close-bg-hover rgba(255, 255, 255, 0.15); */
/* @define-color text-color #${COLOR_07}; */
/* @define-color text-color-disabled rgb(150, 150, 150); */
/* @define-color bg-selected rgb(0, 128, 255); */


@define-color cc-bg @COLOR_BG;
@define-color noti-border-color rgba(255, 255, 255, 0.15);
@define-color noti-bg @COLOR_BG;
@define-color noti-bg-opaque @COLOR_BG;
@define-color noti-bg-darker rgb(38, 38, 38);
@define-color noti-bg-hover @COLOR_00;
@define-color noti-bg-hover-opaque @COLOR_00;
@define-color noti-bg-focus rgba(68, 68, 68, 0.6);
@define-color noti-close-bg rgba(255, 255, 255, 0.1);
@define-color noti-close-bg-hover rgba(255, 255, 255, 0.15);
@define-color text-color @COLOR_FG;
@define-color text-color-disabled rgb(150, 150, 150);
@define-color bg-selected rgb(0, 128, 255);
EOF
