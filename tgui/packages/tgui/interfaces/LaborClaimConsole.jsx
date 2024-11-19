import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const LaborClaimConsole = (props) => {
  const { act, data } = useBackend();
  const { can_go_home, id_points, ores, status_info, unclaimed_points } = data;
  return (
    <Window width={315} height={440}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="状态">{status_info}</LabeledList.Item>
            <LabeledList.Item label="飞船控制">
              <Button
                content="移动飞船"
                disabled={!can_go_home}
                onClick={() => act('move_shuttle')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="点数">{id_points}</LabeledList.Item>
            <LabeledList.Item
              label="无主点数"
              buttons={
                <Button
                  content="认领点数"
                  disabled={!unclaimed_points}
                  onClick={() => act('claim_points')}
                />
              }
            >
              {unclaimed_points}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="用法说明">
          附近的堆垛机将卸载板条箱并收集冶炼材料，根据交付材料的体积来计算分数.
          <br />
          请注意，只有印有我们的生存质量印章的板材，例如由营地冶炼炉生产的板材，才会被接受为劳改证明.
        </Section>
      </Window.Content>
    </Window>
  );
};
