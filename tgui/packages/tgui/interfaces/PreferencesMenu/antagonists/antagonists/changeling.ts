import { Antagonist, Category } from '../base';

export const CHANGELING_MECHANICAL_DESCRIPTION = `
通过变形将自己伪装成不同的身份, 运用收集到的DNA从一整个生物武器库中选择进化.
`;

const Changeling: Antagonist = {
  key: 'changeling',
  name: '化形',
  description: [
    `
      一种拥有高度智能的外星捕食者，能够随意改变自己外形，完美地模仿人类.
    `,
    CHANGELING_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Changeling;
