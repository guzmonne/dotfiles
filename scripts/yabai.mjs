#!/usr/bin/env zx

// Set the verbosity level through the `DEBUG` environment variable.
$.verbose = Boolean(process.env.DEBUG);

// Global Config
const CONFIG = {
  alacritty: ["Alacritty", [1, 1, 1]],
  arc: ["Arc", [1, 2, 2]],
  brave: ["Brave Browser", [1, 2, 2]],
  firefox: ["Firefox Developer Edition", [1, 2, 2]],
  safari: ["Safari", [1, 2, 2]],
  outlook: ["Microsoft Outlook", [1, 2, 3]],
  slack: ["Slack", [1, 2, 3]],
  fantastical: ["Fantastical", [1, 2, 3]],
  spotify: ["Spotify", [1, 2, 3]],
};
const APPS = Object.values(CONFIG).map((v) => v[0]);

//
// Displays
//
async function displays(args = []) {
  const cmd = args[0];
  const index = args[1] || args[0];

  switch (cmd) {
    case "focus":
      return displayFocus(index);
    case "spaces":
      return displaySpaces(index);
    case "empty-space":
      return displayEmptySpace(index);
    case "get":
    default:
      return displayGet(index);
  }
}
/**
 * Gets the display list or a single display.
 * @param {number} index - Display index.
 */
async function displayGet(index) {
  const displays = JSON.parse(await $`yabai -m query --displays`);

  return index
    ? displays.find((d) => d.index == parseInt(index, 10))
    : displays;
}
/**
 * Finds or creates an empty space inside the display.
 * @param {number} index - Display index.
 */
async function displayEmptySpace(index) {
  // Get the list of spaces in the Display that don't have any windows (empty)
  const emptySpaces = (await spaceGet()).filter(
    (s) => s.display == index && s.windows.length == 0,
  );

  if (emptySpaces.length == 0) return spaceCreate(index);

  return emptySpaces[0];
}
/**
 * Focus on a display.
 * @param {number} index - Display index.
 */
async function displayFocus(index) {
  await $`yabai -m display --focus ${index}`;
}
/**
 * Gets all spaces inside a display.
 * @param {number} index - Display index.
 */
async function displaySpaces(index) {
  return JSON.parse(await $`yabai -m query --spaces --display ${index}`);
}
//
// Windows
//
async function windows(args = []) {
  const cmd = args[0];
  const index = args[1] || args[0];

  switch (cmd) {
    case "close":
      return windowClose(index);
    case "get":
    default:
      return windowGet(index);
  }
}
/**
 * Gets the windows list or a single window.
 * @param {number} index - Window index.
 */
async function windowGet(index) {
  const windows = JSON.parse(await $`yabai -m query --windows`);

  return index ? windows.find((d) => d.index == parseInt(index, 10)) : windows;
}
/**
 * Closes a window
 * @param {number} index - Window index
 */
async function windowClose(index) {
  await $`yabai -m window --close ${index}`;
}
//
// Spaces
//
async function spaces(args = []) {
  const cmd = args[0];
  const index = args[1] || args[0];
  const display = args[2];

  switch (cmd) {
    case "destroy":
      return spaceDestroy(index);
    case "create":
      return spaceCreate(index);
    case "focus":
      return spaceFocus(index);
    case "display":
      return spaceDisplay(index, display);
    case "get":
    default:
      return spaceGet(index);
  }
}
/**
 * Returns the spaces list or a single space.
 * @param {number} index - Space index.
 */
async function spaceGet(index) {
  const spaces = JSON.parse(await $`yabai -m query --spaces`);

  return index ? spaces.find((d) => d.index == parseInt(index, 10)) : spaces;
}
/**
 * Destroys a space
 * @param {number} index - Space index.
 */
async function spaceDestroy(index) {
  const space = await spaceGet(index);

  if (!space) return;

  if (space.windows.length !== 0) {
    console.warn(
      `Can't delete non-empty space (${space.windows.length}) ${index}`,
    );
    return;
  }

  await $`yabai -m space ${index} --destroy`;
}
/**
 * Creates a new space in the indicated display.
 * @param {number} display - Display index.
 */
async function spaceCreate(display) {
  await $`yabai -m space --create ${display}`;

  const emptySpaces = (await spaceGet()).filter(
    (s) => s.display == display && s.windows.length == 0,
  );

  console.log(emptySpaces);

  if (emptySpaces.length == 0)
    throw new Error(`Can't create space on display ${display}`);

  return emptySpaces[0];
}
/**
 * Focus on a space.
 * @param {number} index - Space index.
 */
async function spaceFocus(index) {
  const focusedSpace = (await spaces()).find((s) => s["has-focus"]);

  // The `yabai` command will fail it we try to set focus on an already focused state.
  if (focusedSpace.index == parseInt(index, 10)) return;

  await $`yabai -m space --focus ${index}`;
}
/**
 * Adds a label to a space.
 * @param {number} index - Space index.
 * @param {string} label - Label to add.
 */
async function spaceLabel(index, label) {
  await $`yabai -m space ${index} --label ${label}`;
}
/**
 * Assigns a space to a specific display.
 * @param {number} index - Space index.
 * @param {number} display - Display index.
 */
async function spaceDisplay(index, display) {
  const space = await spaceGet(index);

  if (!space) throw new Error(`Can't find space with index ${index}`);

  // Avoid having yabai blow because the space already belongs to the display
  if (space.display == parseInt(display, 10)) return;

  await $`yabai -m space ${index} --display ${display}`;
}
//
// Apps
//
async function apps(args = []) {
  const cmd = args[0];
  const name = args[1] || args[0];
  const index = args[2];
  const label = args[3];

  switch (cmd) {
    case "launch":
      return appLaunch(name, index, label);
    case "open":
      return appOpen(name, index);
    case "close":
      return appClose(name);
    case "space":
      return appSpace(name, index);
    case "focus":
      return appFocus(name);
    case "get":
    default:
      return appGet(name);
  }
}
/**
 * Gets an application by name.
 * @param {string} name - Application name.
 */
async function appGet(name) {
  return (await windowGet()).find((w) => w.app == name);
}
/**
 * Opens an app on a given space.
 * @param {string} name - Application name.
 * @param {number} index - Space index.
 */
async function appOpen(name, space = 1) {
  await spaceFocus(space);
  await $`echo -n 'display notification "Opening ${name}" with title "Yabai Launch"'`.pipe(
    $`/usr/bin/env osascript`,
  );
  await $`open /Applications/${name}.app`;

  // Wait until the application loads.
  while (true) {
    await sleep(1000);
    const app = await appGet(name);
    if (app) break;
  }

  await appSpace(name, space);

  return appGet(name);
}
/**
 * Closes an application.
 * @param {string} name - Application name.
 */
async function appClose(name) {
  const app = await appGet(name);

  if (!app) {
    console.log(`Can't find app ${name}`);
    return;
  }

  await $`yabai -m window --close ${app.id}`;

  while (true) {
    console.log("Waiting for app to be deleted");
    try {
      const deletedApp = await appGet(name);

      if (!deletedApp) break;

      console.log("App is still up. Waiting 3 seconds.");
      await sleep(3000);
    } catch (e) {
      console.error(e);
      break;
    }
  }
}
/**
 * Moves an app to a new space
 * @param {string} name - Application name.
 * @param {number} index - Space index.
 */
async function appSpace(name, index) {
  const app = await appGet(name);

  if (app.space == index) return;

  await $`yabai -m window ${app.id} --space ${index}`;

  await appFocus(name);
}
/**
 * Focus on an app
 * @param {string} name - Application name.
 */
async function appFocus(name) {
  if (name === "last") {
    await $`yabai -m window --focus last`;
    return;
  }

  const app = await appGet(name);

  if (app["has-focus"]) return;

  await $`yabai -m window ${app.id} --focus`;
}
/**
 * Launchs an app or moves it to a new display on an empty space.
 * @param {string} name - Application name.
 * @param {number} display - Display index.
 * @param {string} label - Label to identify the new space.
 */
async function appLaunch(name, display = 1, label) {
  if (!label) label = name;

  let app = await appGet(name);

  if (!app) {
    let space = await displayEmptySpace(display);
    console.log(`Opening app: ${name}`);
    app = await appOpen(name, space.index);
  }

  if (app.display == display) {
    // We need to check tha the app is alone on its space.
    const appsInSpace = (await windowGet()).filter((w) => w.space == app.space);

    // If the app is the only one in the space, then do nothing
    if (appsInSpace.length == 1) {
      console.log(`App ${name} is open and on the right display (${display})`);
      return;
    }
  }

  let space = await displayEmptySpace(display);
  await spaceLabel(space.index, label);
  await ruleAdd(label, name, space.index, display);

  console.log(`Moving app from space ${app.space} to ${space.index}`);
  return await appSpace(name, space.index);
}
//
// Rules
//
async function rules(args = []) {
  const cmd = args[0];
  const label = args[1];
  const name = args[2];
  const display = args[3];

  switch (cmd) {
    case "add":
      return ruleAdd(label, name, display);
    case "remove":
      return ruleRemove(label);
    case "get":
    default:
      return ruleGet(label);
  }
}
/**
 * Gets the list of rules.
 * @param {string} label - Rule label.
 */
async function ruleGet(label) {
  const rules = JSON.parse(await $`yabai -m rule --list`);

  return label ? rules.find((r) => r.label == label) : rules;
}
/**
 * Adds a new rule to handle the app.
 * @param {string} label - Rule label.
 * @param {string} name - Application name.
 * @param {string} space - Space index.
 * @param {number} display - Display index.
 */
async function ruleAdd(label, name, space, display) {
  await ruleRemove(label);
  await $`yabai -m rule --add label=${label} app=${name} space=${space} display=${display}`;
}
/**
 * Removes a rule by application label.
 * @param {string} label - Application label.
 */
async function ruleRemove(label) {
  const rule = await ruleGet(label);

  if (!rule) return;

  await $`yabai -m rule --remove ${label}`;
}
//
// Setup
//
/**
 * Sets my development environment.
 * @param {number} monitors - Number of monitors.
 */
async function setup(monitors = 3) {
  for (let [key, tuple] of Object.entries(CONFIG)) {
    console.log({ key, tuple });
    await appLaunch(tuple[0], tuple[1][monitors - 1], key);
  }
}
/**
 * Cleans the current applications setup.
 */
async function clean() {
  const windows = await windowGet();
  const apps = APPS.slice(1);

  for (const w of windows) {
    if (!apps.includes(w.app)) {
      console.log(`App ${w.app} doesn't belong to the list of managed APPS`);
      continue;
    }

    console.log(`Closing App ${w.app}`);
    await appClose(w.app);
    console.log(`Closing Space ${w.space}`);
    await spaceDestroy(w.space);
  }
}
/**
 * Relabel spaces.
 */
async function relabel() {
  const windows = await windowGet();
  const labels = Object.entries(CONFIG).reduce(
    (acc, [key, value]) => ({
      ...acc,
      [value[0]]: key,
    }),
    {},
  );

  console.log(labels);

  for (const w of windows) {
    if (!APPS.includes(w.app)) {
      console.log(`App ${w.app} not managed`);
      continue;
    }
    const label = labels[w.app];

    if (!label) {
      console.log(`Couldn't find a label for app ${w.app}`);
      continue;
    }

    console.log(`Applying label ${label} for app ${w.app}`);
    await $`yabai -m space ${w.space} --label ${label}`;
  }
}
//
// Main function
//
async function main() {
  const cmd = process.argv[3];
  const args = process.argv.slice(4);

  switch (cmd) {
    case "displays":
      return displays(args);
    case "windows":
      return windows(args);
    case "spaces":
      return spaces(args);
    case "apps":
      return apps(args);
    case "rules":
      return rules(args);
    case "setup":
      return setup(args);
    case "clean":
      return clean(args);
    case "relabel":
      return relabel(args);
    default:
      throw new Error(`Unknown command ${cmd}`);
  }
}

// Entrypoint
main()
  .then((r) => {
    r && console.log(r);
    return appFocus("last");
  })
  .catch((e) => console.error(e));
