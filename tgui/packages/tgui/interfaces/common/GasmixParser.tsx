import { Box, Button, LabeledList } from '../../components';

export type Gasmix = {
  name?: string;
  gases: [string, string, number][]; // ID, name, and amount.
  temperature: number;
  volume: number;
  pressure: number;
  total_moles: number;
  reactions: [string, string, number][]; // ID, name, and amount.
  reference: string;
};

type GasmixParserProps = {
  gasmix: Gasmix;
  gasesOnClick?: (gas_id: string) => void;
  temperatureOnClick?: () => void;
  volumeOnClick?: () => void;
  pressureOnClick?: () => void;
  reactionOnClick?: (reaction_id: string) => void;
  // Whether we need to show the number of the reaction or not
  detailedReactions?: boolean;
};

export const GasmixParser = (props: GasmixParserProps) => {
  const {
    gasmix,
    gasesOnClick,
    temperatureOnClick,
    volumeOnClick,
    pressureOnClick,
    reactionOnClick,
    detailedReactions,
    ...rest
  } = props;

  const { gases, temperature, volume, pressure, total_moles, reactions } =
    gasmix;

  return !total_moles ? (
    <Box nowrap italic mb="10px">
      {'未检测到气体!'}
    </Box>
  ) : (
    <LabeledList {...rest}>
      {gases.map((gas) => (
        <LabeledList.Item
          label={
            gasesOnClick ? (
              <Button content={gas[1]} onClick={() => gasesOnClick(gas[0])} />
            ) : (
              gas[1]
            )
          }
          key={gas[1]}
        >
          {gas[2].toFixed(2) +
            ' mol (' +
            ((gas[2] / total_moles) * 100).toFixed(2) +
            ' %)'}
        </LabeledList.Item>
      ))}
      <LabeledList.Item
        label={
          temperatureOnClick ? (
            <Button
              content={'温度'}
              onClick={() => temperatureOnClick()}
            />
          ) : (
            '温度'
          )
        }
      >
        {(total_moles ? temperature.toFixed(2) : '-') + ' K'}
      </LabeledList.Item>
      <LabeledList.Item
        label={
          volumeOnClick ? (
            <Button content={'体积'} onClick={() => volumeOnClick()} />
          ) : (
            '体积'
          )
        }
      >
        {(total_moles ? volume.toFixed(2) : '-') + ' L'}
      </LabeledList.Item>
      <LabeledList.Item
        label={
          pressureOnClick ? (
            <Button content={'压强'} onClick={() => pressureOnClick()} />
          ) : (
            '压强'
          )
        }
      >
        {(total_moles ? pressure.toFixed(2) : '-') + ' kPa'}
      </LabeledList.Item>
      {detailedReactions ? (
        reactions.map((reaction) => (
          <LabeledList.Item
            key={`${gasmix.reference}-${reaction[0]}`}
            label={
              reactionOnClick ? (
                <Button
                  content={reaction[1]}
                  onClick={() => reactionOnClick(reaction[0])}
                />
              ) : (
                reaction[1]
              )
            }
          >
            {reaction[2]}
          </LabeledList.Item>
        ))
      ) : (
        <LabeledList.Item label="气体反应">
          {reactions.length
            ? reactions.map((reaction, index) =>
                reactionOnClick ? (
                  <Box key={reaction[1]} mb="0.5em">
                    <Button
                      content={reaction[1]}
                      onClick={() => reactionOnClick(reaction[0])}
                    />
                  </Box>
                ) : (
                  <div key={reaction[1]}>{reaction[1]}</div>
                ),
              )
            : '未检测到气体反应'}
        </LabeledList.Item>
      )}
    </LabeledList>
  );
};
