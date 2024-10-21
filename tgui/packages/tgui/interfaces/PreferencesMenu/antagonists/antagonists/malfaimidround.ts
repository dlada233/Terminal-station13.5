import { Antagonist, Category } from '../base';
import { MALF_AI_MECHANICAL_DESCRIPTION } from './malfai';

const MalfAIMidround: Antagonist = {
  key: 'malfaimidround',
  name: '键值错位AI',
  description: [
    `
      一种能在游戏中途加入的故障AI.
    `,
    MALF_AI_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default MalfAIMidround;
