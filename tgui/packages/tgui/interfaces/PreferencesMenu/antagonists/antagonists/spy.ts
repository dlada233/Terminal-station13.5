import { Antagonist, Category } from '../base';

const Spy: Antagonist = {
  key: 'spy',
  name: '间谍',
  description: [
    `
      如果你选择接受的话，你的任务将是: 渗透进入13号空间站.
      把自己伪装成他们中的一员并偷走重要的设备.
      如果你被抓或者被杀，我们不会承认知道此事.
      祝你好运，特工.
    `,

    `
      完成间谍委托来赚取报酬.
      用这些报酬制造混乱或者恶作剧!
    `,
  ],
  category: Category.Roundstart,
};

export default Spy;
