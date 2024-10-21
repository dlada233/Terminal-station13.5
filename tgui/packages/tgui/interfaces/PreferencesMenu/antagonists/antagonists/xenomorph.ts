import { Antagonist, Category } from '../base';

const Xenomorph: Antagonist = {
  key: 'xenomorph',
  name: '异形',
  description: [
    `
      从一个异形幼虫开始，不断升级进化，甚至成为女王!
    `,
  ],
  category: Category.Midround,
};

export default Xenomorph;
