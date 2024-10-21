import { Antagonist, Category } from '../base';
import { OPERATIVE_MECHANICAL_DESCRIPTION } from './operative';

const LoneOperative: Antagonist = {
  key: 'loneoperative',
  name: '独狼行动队员',
  description: [
    `
      单独行动的核特工，核认证磁盘在一个地方停留时间越长，生成此反派的概率就越大.
    `,

    OPERATIVE_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default LoneOperative;
