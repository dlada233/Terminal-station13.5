import { Antagonist, Category } from '../base';

const Obsessed: Antagonist = {
  key: 'obsessed',
  name: '痴迷',
  description: [
    `
    你痴迷上了某人! 你的痴迷行为可能会让某些人的注意到私人物品被偷走，同事也失踪不见.
    但他们会意识到自己可能就是你的下一个受害者吗?
    `,
  ],
  category: Category.Midround,
};

export default Obsessed;
