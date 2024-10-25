import { Antagonist, Category } from '../base';

export const WIZARD_MECHANICAL_DESCRIPTION = `
      学习不同的强大法术，在13号空间站上引发巨大的混乱.
    `;

const Wizard: Antagonist = {
  key: 'wizard',
  name: '巫师',
  description: [`"幸会. 我们是巫师联盟的巫师."`, WIZARD_MECHANICAL_DESCRIPTION],
  category: Category.Roundstart,
};

export default Wizard;
