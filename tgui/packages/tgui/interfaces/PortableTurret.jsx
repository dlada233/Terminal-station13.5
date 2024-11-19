import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const PortableTurret = (props) => {
  const { act, data } = useBackend();
  const {
    silicon_user,
    locked,
    on,
    check_weapons,
    neutralize_criminals,
    neutralize_all,
    neutralize_unidentified,
    neutralize_nonmindshielded,
    neutralize_cyborgs,
    neutralize_heads,
    manual_control,
    allow_manual_control,
    lasertag_turret,
  } = data;
  return (
    <Window width={310} height={lasertag_turret ? 110 : 292}>
      <Window.Content>
        <NoticeBox>刷动ID卡以{locked ? '解锁' : '锁定'}该面板.</NoticeBox>
        <>
          <Section>
            <LabeledList>
              <LabeledList.Item
                label="状态"
                buttons={
                  !lasertag_turret &&
                  (!!allow_manual_control ||
                    (!!manual_control && !!silicon_user)) && (
                    <Button
                      icon={manual_control ? 'wifi' : 'terminal'}
                      content={manual_control ? '远程控制' : '手动控制'}
                      disabled={manual_control}
                      color="bad"
                      onClick={() => act('manual')}
                    />
                  )
                }
              >
                <Button
                  icon={on ? 'power-off' : 'times'}
                  content={on ? '开' : '关'}
                  selected={on}
                  disabled={locked}
                  onClick={() => act('power')}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
          {!lasertag_turret && (
            <Section
              title="目标设置"
              buttons={
                <Button.Checkbox
                  checked={!neutralize_heads}
                  content="忽略指挥人员"
                  disabled={locked}
                  onClick={() => act('shootheads')}
                />
              }
            >
              <Button.Checkbox
                fluid
                checked={neutralize_all}
                content="Non-Security and Non-Command"
                disabled={locked}
                onClick={() => act('shootall')}
              />
              <Button.Checkbox
                fluid
                checked={check_weapons}
                content="Unauthorized Weapons"
                disabled={locked}
                onClick={() => act('authweapon')}
              />
              <Button.Checkbox
                fluid
                checked={neutralize_unidentified}
                content="Unidentified Life Signs"
                disabled={locked}
                onClick={() => act('checkxenos')}
              />
              <Button.Checkbox
                fluid
                checked={neutralize_nonmindshielded}
                content="Non-Mindshielded"
                disabled={locked}
                onClick={() => act('checkloyal')}
              />
              <Button.Checkbox
                fluid
                checked={neutralize_criminals}
                content="Wanted Criminals"
                disabled={locked}
                onClick={() => act('shootcriminals')}
              />
              <Button.Checkbox
                fluid
                checked={neutralize_cyborgs}
                content="Cyborgs"
                disabled={locked}
                onClick={() => act('shootborgs')}
              />
            </Section>
          )}
        </>
      </Window.Content>
    </Window>
  );
};
