// THIS IS A SKYRAT UI FILE
import { Antagonist, Category } from '../base';

export const OPERATIVE_MECHANICAL_DESCRIPTION = `
  设法取得所有GoldenEye-黄金眼的认证密钥，并最终使用密钥激活GoldenEye-黄金眼.
  密钥被分成了思维碎片藏在纳米传讯员工的头脑内，使用审问者提取这些思维碎片.
`;

const AssaultOperative: Antagonist = {
  key: 'assaultoperative',
  name: '突击特工',
  description: [
    `
      下午好, 0013, 你已被选中进入到一支精英突击队，专门负责获取GoldenEye-黄金眼
      的认证密钥. 你的任务是获取这些钥匙，然后让纳米传讯的GoldenEye-黄金眼的防御网络
      反过来对付他们自己，GoldenEye-黄金眼防御网络需要三把钥匙才能激活.
    `,

    OPERATIVE_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default AssaultOperative;
