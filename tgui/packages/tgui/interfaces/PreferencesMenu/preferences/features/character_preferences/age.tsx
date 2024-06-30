import { Feature, FeatureNumberInput } from '../base';

export const age: Feature<number> = {
  // name: 'Age', // ORIGINAL
  name: '年龄 (生理)', // SKYRAT EDIT CHANGE - Chronological age
  // SKYRAT EDIT ADDITION BEGIN - Chronological age
  description:
    "Physical age represents how far your character has grown physically and mentally.\
    Includes 'normal' aging, such as experiences which physically age the body, and 'anti-aging' medical procedures.\
    Does not include time spent in cryo-sleep.",
  // SKYRAT EDIT ADDITION END
  component: FeatureNumberInput,
};
