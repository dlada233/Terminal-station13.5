import { Antagonist, Category } from '../base';

const Abductor: Antagonist = {
  key: 'abductor',
  name: '劫持者',
  description: [
    `
      劫持者是技术先进的外星文明，致力于对所有物种进行研究编目.
      不幸的是，对于被编目生物来说，他们的方法具有相当的侵犯性.
    `,

    `
      你将和一名搭档结成科学家与特工二人组合.
      担当特工时，你需要绑架实验对象并带回UFO.
      担当科学家时，你需要为地面特工寻找绑架对象、提供信息支援以及对带回来的实验对象
      进行手术.
    `,
  ],
  category: Category.Midround,
};

export default Abductor;
