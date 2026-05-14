import { Meta, StoryObj } from "@storybook/react";
import { Tes } from "./Tes";

const asdf = {
  name: "asdf",
};

const meta: Meta<typeof Tes> = {
  title: "components/Tes",
  component: Tes,
  tags: ["autodocs"],
};
export default meta;

type Story = StoryObj<typeof Tes>;

export const jk: Story = {
  args: {
    // props here
  },
};
