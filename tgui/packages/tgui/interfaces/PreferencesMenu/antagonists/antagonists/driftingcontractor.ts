// THIS IS A SKYRAT UI FILE

import { Antagonist, Category } from '../base';

export const CONTRACTOR_MECHANICAL_DESCRIPTION = `
      潜入进空间站，完成尽可能多的契约合同!
    `;

const DriftingContractor: Antagonist = {
  key: 'driftingcontractor',
  name: '契约特工',
  description: [
    `会在站点附近生成的辛迪加特工，装备了顶级的契约特工装备，目的在于完成尽可能多的
    契约合同.`,
    CONTRACTOR_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default DriftingContractor;
