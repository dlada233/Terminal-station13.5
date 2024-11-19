// THIS IS A SKYRAT UI FILE
import { BlockQuote, Box, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const DelamProcedure = () => {
  return (
    <Window title="安全蛾 - 分层紧急程序" width={666} height={865} theme="dark">
      <Window.Content>
        <Section title="NT-分层应急程序">
          <NoticeBox danger m={2}>
            <b>
              所以你发现自己陷入了一场超物质反应堆分层事故的困境中.
              <br />
              <br />
              别担心，挽救整个局面就在几步之内!
            </b>
          </NoticeBox>
          <BlockQuote m={2}>
            找到不那么明显的红色紧急停止按钮. 它可能就隐藏在你视野里的某处，
            所以放轻松，笑一笑，就当是在玩寻宝游戏，只是奖励是制止核灾难.
          </BlockQuote>
          <BlockQuote m={2}>
            一旦你找到了那个按钮，就义无反顾地按下它，按得好像你已经没有明天了那样；
            但实际上，你这么做是为了有明天.
            也许蕴含了某种二元对立转化的辩证思想?
          </BlockQuote>
          <BlockQuote m={2}>
            紧急停止措施将对整个超物质反应室里进行压制，一切都将变得非常安静.
            确保 大家都已经疏散了，否则他们可能会收到一些惊喜.
            这个系统需要一定的空间， 并且不是一个友善的邻居.
          </BlockQuote>
          <BlockQuote m={2}>
            在分层成功被抑制后，花点时间来欣赏超物质水晶的精致之美. 检查
            一下周围，修复那些玻璃部件，打扫一下现场.
          </BlockQuote>
          <BlockQuote m={2}>
            最好穿上你最好的工作服，必须小心火灾以及有害气体.
            记住，氧气加上火花等于
            焰火，你绝对不想在超物质旁边看到焰火；所以做好复杂的大气管理，而不是单单
            让不知名气体弥漫全场.
          </BlockQuote>
          <NoticeBox info m={2}>
            <b>
              你知道氟利氧会在低温下着火吗?
              <br />
              <br />
              它甚至在120K到160K之间会形成热冰!
              <br />
              <br />
              记住你总是可以通过设置大气警报来让通风设备帮助你清除有害气体!
            </b>
          </NoticeBox>
          <BlockQuote m={2}>
            为了避免眉毛被烧焦，可以考虑找个值得信赖的合成人或者赛博帮忙.
            或者直接把灭火工作外包给没有呼吸需求的人.
          </BlockQuote>
          <BlockQuote m={2}>
            清除任何放射性残骸或热冰(货仓部门可能很乐意为你回收它们.)
          </BlockQuote>
          <BlockQuote m={2}>
            最终，当你意识到你以一己之力阻止了分层时，成就感油然而生.
            但是，当然，不要忘记感到内疚，因为安全蛾知道. 安全蛾无所不知.
            它总是在观察、判断，还可能会为下一次安全简报做记录. 尽情
            享受在成为英雄的荣耀吧，但要知道无所不知的蛾已经盯上你的了.
          </BlockQuote>
          <Box m={2}>
            <b>可选步骤，为那些真正的冒险者准备</b>
          </Box>
          <BlockQuote m={2}>
            当你第二次尝试启动SM时，拿起这个标志，把它朝水晶扔过去，看着它在空中飞过.{' '}
            <br />
            <br />
            没有人说我正在处理一个潜在的灾难性情况；比如搞一些异想天开的恶作剧.
          </BlockQuote>
          <NoticeBox m={2}>
            <b>希望你永远用不到这个，祝你好运!</b>
          </NoticeBox>
        </Section>
      </Window.Content>
    </Window>
  );
};
