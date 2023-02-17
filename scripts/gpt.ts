#!/usr/bin/env ts-node
import { CodeEngine } from "prompt-engine";
import dedent from "dedent";
import {
  command,
  positional,
  run,
  string,
  option,
  multioption,
  array,
} from "cmd-ts";

const app = command({
  name: "gpt.ts",
  description: "Simple CLI to communicate with GPT through the CLI.",
  version: "1.0.0",
  args: {
    query: positional({
      description: "The query to run.",
      type: string,
      displayName: "Query",
    }),
    description: option({
      long: "description",
      short: "d",
      defaultValue: () => "Natural Language Commands to develop applications",
      type: string,
      description: dedent`
        Prompt description which should give context about the programming language the model
        should generate and libraries it should be using.
      `
        .split("\n")
        .join(""),
    }),
    commentOperator: option({
      long: "comment-operator",
      short: "c",
      defaultValue: () => "//",
      type: string,
      description: dedent`
        The operator to use for comments.
      `
        .split("\n")
        .join(""),
    }),
    input: multioption({
      description: dedent`
        Example input exemplifying the kind of code you expect the model to produce.
        Every input should be accompanied by a response option.
      `
        .split("\n")
        .join(""),
      short: "i",
      long: "input",
      type: array(string),
    }),
    response: multioption({
      description: dedent`
        Example response exemplifying the kind of code you expect the model to produce.
        Every input should be accompanied by an input option.
      `
        .split("\n")
        .join(""),
      short: "r",
      long: "response",
      type: array(string),
    }),
  },
  handler: async ({ description, input, response, query, commentOperator }) => {
    const examples = input.map((i, index) => ({
      input: i,
      response: response[index],
    }));

    const codeEngine = new CodeEngine(description, examples, undefined, {
      commentOperator,
    });

    const prompt = codeEngine.buildPrompt(query);

    console.log(prompt);
  },
});

run(app, process.argv.slice(2));
