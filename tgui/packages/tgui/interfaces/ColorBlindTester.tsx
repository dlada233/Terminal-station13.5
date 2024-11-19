import { useBackend } from '../backend';
import { Box, Button, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  details: string[];
  selected: string;
};

type Props = {
  category: string;
};

const UI_WARNINGS = [
  `嘿混蛋，这些滤镜基于老旧且有缺陷的matrixes..`,
  `在BYOND里没有好的方法做正确的色盲模拟，因为我们没有办法在不遍历
屏幕上所有像素的情况下提取像素的伽马值，而为了准确校正人眼视觉，这是必须进行的步骤.`,
  `因为这个原因，这种模拟非常的不完善. 你会注意到
事物的亮度比实际应有的亮度要高的多. 这是无法校正伽马值的直接结果.`,
  `这个工具的存在是为了让我们在可访问性方面至少有一个基准，但它绝非绝对的标准.`,
  `如果我发现你因为这件事而对别人无理取闹，我会用撬棍狠狠地揍你一顿.`,
] as const;

export const ColorBlindTester = (props) => {
  const { data } = useBackend<Data>();
  const { details } = data;

  return (
    <Window title="色盲测试" width={600} height={515}>
      <Window.Content>
        <NoticeBox>
          {UI_WARNINGS.map((warning, index) => (
            <Box key={index}>{warning}</Box>
          ))}
        </NoticeBox>
        <Section>
          {Object.keys(details).map((category) => (
            <ColorBlindCategory category={category} key={category} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};

const ColorBlindCategory = (props: Props) => {
  const { act, data } = useBackend<Data>();
  const { category } = props;
  const { details, selected } = data;

  if (category !== selected) {
    return (
      <Section
        key={category}
        title={category}
        buttons={
          <Button
            icon="eye"
            content="选择"
            onClick={() =>
              act('set_matrix', {
                name: category,
              })
            }
          />
        }
      >
        {details[category]}
      </Section>
    );
  }
  return (
    <Section
      key={category}
      title={category}
      buttons={
        <Button
          icon="times"
          content="清除"
          color="bad"
          onClick={() => act('clear_matrix')}
        />
      }
    >
      {details[category]}
    </Section>
  );
};
