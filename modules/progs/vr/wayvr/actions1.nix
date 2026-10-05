[
  {
    profile = "/interaction_profiles/ext/eye_gaze_interaction";
    pose = {
      handsfree = "/user/eyes_ext/input/gaze_ext/pose";
    };
  }
  {
    profile = "/interaction_profiles/ext/hand_interaction_ext";
    click = {
      handsfree = "/user/hand/right/input/pinch_ext/value";
    };
    grab = {
      handsfree = "/user/hand/left/input/pinch_ext/value";
    };
  }
  {
    profile = "/interaction_profiles/oculus/touch_controller";
    pose = {
      left = "/user/hand/left/input/aim/pose";
      right = "/user/hand/right/input/asim/pose";
    };
    click = {
      left = "/user/hand/left/input/trigger/value";
      right = "/user/hand/right/input/trigger/value";
    };
    grab = {
      left = "/user/hand/left/input/squeeze/value";
      right = "/user/hand/right/input/squeeze/value";
    };
    alt_click = {
    };
    show_hide = {
      left = "/user/hand/left/input/menu/click";
    };
    toggle_dashboard = {
    };
    space_drag = {
      right = "/user/hand/right/input/thumbstick/click";
      double_click = false;
    };
    space_rotate = {
      left = "/user/hand/left/input/thumbstick/click";
    };
    space_reset = {
      left_chord = [
        "/user/hand/left/input/squeeze/value"
        "/user/hand/left/input/thumbstick/click"
      ];
      right_chord = [
        "/user/hand/right/input/squeeze/value"
        "/user/hand/right/input/thumbstick/click"
      ];
      double_click = false;
    };
    click_modifier_right = {
      left = "/user/hand/left/input/y/touch";
      right = "/user/hand/right/input/b/touch";
    };
    click_modifier_middle = {
      left = "/user/hand/left/input/x/touch";
      right = "/user/hand/right/input/a/touch";
    };
    move_mouse = {
      left = "/user/hand/left/input/trigger/touch";
      right = "/user/hand/right/input/trigger/touch";
    };
    scroll = {
      left = "/user/hand/left/input/thumbstick/y";
      right = "/user/hand/right/input/thumbstick/y";
    };
    haptic = {
      left = "/user/hand/left/output/haptic";
      right = "/user/hand/right/output/haptic";
    };
  }
]
