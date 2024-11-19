import { Antagonist, Category } from '../base';

export const OPERATIVE_MECHANICAL_DESCRIPTION = `
  找回核认证软盘，用它来启动核裂变炸弹摧毁整个空间站.
`;

const Operative: Antagonist = {
  key: 'operative',
  name: '核特工',
  description: [
    `
      恭喜你，特工. 你已经被选入辛迪加核行动突击队.
      不管你愿不愿意接受，你的任务就是摧毁纳米传讯最先进的研究设施.
      没错，你将前往13号空间站.
    `,

    OPERATIVE_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Operative;
