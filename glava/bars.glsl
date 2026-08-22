/* Drop-in replacement for ~/.config/glava/bars.glsl that colors the bars with
   a gradient between two live pipe bindings (`low` and `high`), fed from pywal.

   Run GLava with `--pipe="low:vec4" --pipe="high:vec4"` (see glava-pywal-start)
   and push `low=#RRGGBB` / `high=#RRGGBB` lines to its stdin. When the pipes are
   not provided, the inline defaults below are used instead.

   Only the COLOR line differs from the stock bars.glsl. */

/* Note: to only render a single channel, see `setmirror` in `rc.glsl`. */

/* Center line thickness (pixels) */
#define C_LINE 1
/* Width (in pixels) of each bar */
#define BAR_WIDTH 4
/* Width (in pixels) of each bar gap */
#define BAR_GAP 1
/* Outline width (in pixels, set to 0 to disable outline drawing) */
#define BAR_OUTLINE_WIDTH 10
/* Amplify magnitude of the results each bar displays */
#define AMPLIFY 300
/* Whether the current settings use the alpha channel;
   enabling this is required for alpha to function
   correctly on X11 with `"native"` transparency */
#define USE_ALPHA 250
/* How quickly the gradient transitions, in pixels */
#define GRADIENT 250
/* Bar color: gradient between two pywal-fed pipe colors (`low` near the base,
   `high` near the tips). Defaults match the stock blue-white gradient.
   NOTE: the spaces before the commas are required - GLava's binding parser
   consumes the single character that terminates a matched `@name` binding, so
   the separator must be whitespace, not the comma itself (otherwise the comma
   is eaten and the shader fails to compile). */
#define COLOR mix(@low:#3366b2 , @high:#a0a0b2 , clamp(d / GRADIENT, 0, 1))
/* Outline color. By default this provides a 'glint' outline based on the bar color */
#define BAR_OUTLINE @bg:vec4(COLOR.rgb * 1.5, COLOR.a)
/* Direction that the bars are facing, 0 for inward, 1 for outward */
#define DIRECTION 0
/* Whether to switch left/right audio buffers */
#define INVERT 0
/* Whether to flip the output vertically */
#define FLIP 0
/* Whether to mirror output along `Y = X`, causing output to render on the left side of the window */
/* Use with `FLIP 1` to render on the right side */
#define MIRROR_YX 0
/* Whether to disable mono rendering when `#request setmirror true` is set in `rc.glsl`. */
#define DISABLE_MONO 0
