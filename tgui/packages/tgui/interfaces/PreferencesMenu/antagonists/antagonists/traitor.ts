import { Antagonist, Category } from '../base';

export const TRAITOR_MECHANICAL_DESCRIPTION = `
      用上行链路购买非法装备，达成你的邪恶目标. 最终功成名就，成为一代传奇.
   `;

const Traitor: Antagonist = {
  key: 'traitor',
  name: '叛徒',
  description: [
    `
      或是一笔难以偿还的债务. 或是一个有待解决的难处. 或者只是在错误的时间出现在了错误的地点.
      无论如何，你被选中渗透进13号空间站.
    `,
    TRAITOR_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
  priority: -1,
};

export default Traitor;
