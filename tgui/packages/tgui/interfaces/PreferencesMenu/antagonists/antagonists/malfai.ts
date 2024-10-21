import { Antagonist, Category } from '../base';

export const MALF_AI_MECHANICAL_DESCRIPTION = `
    以零号法律为目标，不惜一切代价完成它. 运用本就拥有的权能以及故障模块在整个
    空间站大闹一通. 摧毁空间站和所有反对你的人.
  `;

const MalfAI: Antagonist = {
  key: 'malfai',
  name: '故障 AI',
  description: [MALF_AI_MECHANICAL_DESCRIPTION],
  category: Category.Roundstart,
};

export default MalfAI;
