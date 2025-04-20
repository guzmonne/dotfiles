local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local snippets = {
	s(
		"mvc-component",
		fmt(
			[[
import {{ useCallback, useReducer }} from "react";
import type {{ PropsWithChildren }} from "react";

// Define the `{1}` type
export type {1} = {{
  {2}
}};

// Enums for ActionType and Event
enum ActionType {{
  NoOp = "NO_OP",
  {3}
}}

enum Event {{
  Idle = "IDLE",
  Loading = "LOADING",
  Error = "ERROR",
}}

// Define the `State` shape
type State = {{
  {4}s: {1}[];
  event: Event;
  error?: string;
}};

// Define the `Action` shape
type Action = {{
  type: ActionType;
  payload?: Partial<State>;
}};

// Reducer function to handle state transitions
function reducer(state: State, action: Action = {{ type: ActionType.NoOp }}): State {{
  const {{ type, payload = {{}} }} = action;

  switch (type) {{
    {5}
    default:
      return state;
  }}
}}

// Props for the `Container` Component
export type ControllerPropsT = PropsWithChildren<{{
  {6}
}}>;

// Parent container component which handles state & logic
function Container(props: ControllerPropsT) {{
  const [state, dispatch] = useReducer(reducer, {{ {4}s: [], event: Event.Idle }});

  {7}

  return (
    <Component
      loading={{state.event === Event.Loading}}
      {8}
      {4}s={{state.{4}s}}
      {{...props}}
    />
  );
}}

// Props for the presentation `Component`
export type ComponentPropsT = ControllerPropsT & {{
  {9}: () => Promise<void>;
  {4}s: {1}[];
  loading?: boolean;
}};

// Presentation component for UI rendering
function Component({{
  {4}s = [],
  loading = false,
  children,
  {10},
  {9},
}}: ComponentPropsT) {{
  return (
    <div>
      <button onClick={{{9}}} type="button" {11}>
        {{loading ? "Loading..." : children}}
      </button>

      {{{4}s.length > 0 && <pre>{{JSON.stringify({4}s, null, 2)}}</pre>}}
    </div>
  );
}}

// Export the Container as the default export
export default Container;
  ]],
			{
				i(1, "Post"),
				i(
					2,
					[[title: string;
  content: string;]]
				),
				i(
					3,
					[[Fetch = "FETCH",
  FetchSuccess = "FETCH_SUCCESS",
  FetchError = "FETCH_ERROR",]]
				),
				i(4, "item"),
				i(
					5,
					[[case ActionType.Fetch:
      return {
        ...state,
        event: Event.Loading,
      };
    case ActionType.FetchSuccess:
      return {
        ...state,
        items: payload.items || [],
        event: Event.Idle,
      };
    case ActionType.FetchError:
      return {
        ...state,
        event: Event.Error,
      };]]
				),
				i(6, "className?: string; // Optional CSS class for the component"),
				i(
					7,
					[[// Handle click to fetch items
  const handleClick = useCallback(async () => {
    dispatch({ type: ActionType.Fetch });

    try {
      const response = await fetch("/api/items");
      if (response.ok) {
        const data = await response.json();
        dispatch({ type: ActionType.FetchSuccess, payload: { items: data } });
      } else {
        dispatch({ type: ActionType.FetchError, payload: { error: "Failed to fetch items" } });
      }
    } catch {
      dispatch({ type: ActionType.FetchError, payload: { error: "Network error" } });
    }
  }, []);]]
				),
				i(8, "onClick={handleClick}"),
				i(9, "onClick"),
				i(10, "className"),
				i(11, "className={className}"),
			}
		)
	),
}

local M = {}

M.setup = function()
	ls.add_snippets("typescriptreact", snippets)
end

return M
