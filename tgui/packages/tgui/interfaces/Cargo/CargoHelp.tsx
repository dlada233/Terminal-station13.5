import { Box, NoticeBox, Section, Stack } from '../../components';

const ORDER_TEXT = `空间站内的每个部门都可以使用自己的订货终端来进行订货.
        这些部门订单是不消耗任何资金的，只是会让他们的订货终端进入冷却时间.
        此时你的任务就来了: 订单会出现在供应控制台，你需要将货物交付给订货者.
        当货物板条箱正确得到达位置并被正确的方式打开时，货仓预算还会收到这笔部门订单
        的全部价值作为奖励. 所以部门送货工作是整个货仓的良好收入来源.`;

const DISPOSAL_TEXT = `除了MULE送货和人工送货外, 你还可以使用管道运输系统.
        请注意，运输管道破裂可能导致货物遗失(这种情况很罕见).
        同样的，如果你需要处理纸质邮件，将信纸包起来封装好，然后可以用上面相同的方式
        寄出去.`;

export function CargoHelp(props) {
  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Section fill scrollable>
          <Section color="label" title="部门订单">
            {ORDER_TEXT}
            <br />
            <br />
            检视部门订货板条箱，了解板条箱目的地的具体细节.
          </Section>
          <Section title="MULE机器人">
            <Box color="label">
              MULE机器人是移动缓慢但坚定的送货机器人，只需要技术人员简单设置就可以
              自动完成送货任务, 不过它速度很慢，而且可能在运货途中遭到干扰.
            </Box>
            <br />
            <Box bold color="green">
              设置一台MULE很简单:
            </Box>
            <b>1.</b> 将要运送的板条箱拖到MULE旁边.
            <br />
            <b>2.</b> 将要运送的板条箱拖到MULE顶部. 它应该会被自动装载.
            <br />
            <b>3.</b> 打开你的PDA.
            <br />
            <b>4.</b> 单击<i>货运机器人控制</i>.<br />
            <b>5.</b> 单击<i>扫描所有货运机器人</i>.<br />
            <b>6.</b> 选择你的MULE.
            <br />
            <b>7.</b> 单击<i>目的地: (set)</i>.<br />
            <b>8.</b> 选择目的地然后单击OK.
            <br />
            <b>9.</b> 单击<i>继续</i>.
          </Section>
          <Section title="管道运输系统">
            <Box color="label">{DISPOSAL_TEXT}</Box>
            <br />
            <Box bold color="green">
              使用管道运输系统会更加方便:
            </Box>
            <b>1.</b> 用包装纸包裹要发送的物品/板条箱.
            <br />
            <b>2.</b> 使用目的地标记器选择将其发送到哪里.
            <br />
            <b>3.</b> 给包裹打上标记.
            <br />
            <b>4.</b> 将其放到传送带上，让系统自动处理.
            <br />
          </Section>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <NoticeBox textAlign="center" info mb={0}>
          有些问题没有包含在这里？如有疑问，请询问军需官（QM）!
        </NoticeBox>
      </Stack.Item>
    </Stack>
  );
}
