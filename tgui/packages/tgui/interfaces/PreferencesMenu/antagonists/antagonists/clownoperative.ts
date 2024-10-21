import { Antagonist, Category } from '../base';
import { OPERATIVE_MECHANICAL_DESCRIPTION } from './operative';

const ClownOperative: Antagonist = {
  key: 'clownoperative',
  name: '小丑特工',
  description: [
    `
      Honk! 无论如何，你已经被选中加入辛迪加小丑特工队.
      你的任务，无论你是否想去执行它，就是去Honk纳米传讯最先进的研究设施!
      没错，你就要前往13号小丑空间站了.
    `,

    OPERATIVE_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default ClownOperative;
