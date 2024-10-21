import { useBackend } from '../../backend';
import { Box, Button, Icon, LabeledList } from '../../components';

export const ReagentLookup = (props) => {
  const { reagent } = props;
  const { act } = useBackend();
  if (!reagent) {
    return <Box>No reagent selected!</Box>;
  }

  return (
    <LabeledList>
      <LabeledList.Item label="试剂">
        <Icon name="circle" mr={1} color={reagent.reagentCol} />
        {reagent.name}
        <Button
          ml={1}
          icon="wifi"
          color="teal"
          tooltip="打开此试剂的WIKI相关页面."
          tooltipPosition="left"
          onClick={() => {
            Byond.command(`wiki Guide_to_chemistry#${reagent.name}`);
          }}
        />
      </LabeledList.Item>
      <LabeledList.Item label="描述">{reagent.desc}</LabeledList.Item>
      <LabeledList.Item label="pH">
        <Icon name="circle" mr={1} color={reagent.pHCol} />
        {reagent.pH}
      </LabeledList.Item>
      <LabeledList.Item label="特性">
        <LabeledList>
          {!!reagent.OD && (
            <LabeledList.Item label="过量">{reagent.OD}u</LabeledList.Item>
          )}
          {reagent.addictions[0] && (
            <LabeledList.Item label="成瘾">
              {reagent.addictions.map((addiction) => (
                <Box key={addiction}>{addiction}</Box>
              ))}
            </LabeledList.Item>
          )}
          <LabeledList.Item label="代谢率">
            {reagent.metaRate}u/s
          </LabeledList.Item>
        </LabeledList>
      </LabeledList.Item>
      <LabeledList.Item label="杂质">
        <LabeledList>
          {reagent.impureReagent && (
            <LabeledList.Item label="杂质试剂">
              <Button
                icon="vial"
                tooltip="消耗时若纯度高于反纯度，试剂会部分转化为此物质."
                tooltipPosition="left"
                content={reagent.impureReagent}
                onClick={() =>
                  act('reagent_click', {
                    id: reagent.impureId,
                  })
                }
              />
            </LabeledList.Item>
          )}
          {reagent.inverseReagent && (
            <LabeledList.Item label="反试剂">
              <Button
                icon="vial"
                content={reagent.inverseReagent}
                tooltip="消耗时若纯度低于反纯度，该试剂将会转化为此物质."
                tooltipPosition="left"
                onClick={() =>
                  act('reagent_click', {
                    id: reagent.inverseId,
                  })
                }
              />
            </LabeledList.Item>
          )}
          {reagent.failedReagent && (
            <LabeledList.Item label="失败试剂">
              <Button
                icon="vial"
                tooltip="反应完成时若纯度低于最低纯度，该试剂会变成此物质."
                tooltipPosition="left"
                content={reagent.failedReagent}
                onClick={() =>
                  act('reagent_click', {
                    id: reagent.failedId,
                  })
                }
              />
            </LabeledList.Item>
          )}
        </LabeledList>
        {reagent.isImpure && <Box>这种试剂由杂质反应产生.</Box>}
        {reagent.deadProcess && <Box>这种试剂对死者有效.</Box>}
        {!reagent.failedReagent &&
          !reagent.inverseReagent &&
          !reagent.impureReagent && <Box>这种试剂没有杂质试剂.</Box>}
      </LabeledList.Item>
      <LabeledList.Item>
        <Button
          icon="flask"
          mt={2}
          content={'查找相关反应'}
          color="purple"
          onClick={() =>
            act('find_reagent_reaction', {
              id: reagent.id,
            })
          }
        />
      </LabeledList.Item>
    </LabeledList>
  );
};
