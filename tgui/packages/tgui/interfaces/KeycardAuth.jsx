import { useBackend } from '../backend';
import { Box, Button, Section } from '../components';
import { Window } from '../layouts';

export const KeycardAuth = (props) => {
  const { act, data } = useBackend();
  return (
    // SKYRAT EDIT: height 125 -> 190, eng override/firing pin
    <Window width={375} height={190}>
      <Window.Content>
        <Section>
          <Box>
            {data.waiting === 1 && <span>请等待另一台设备确认请求...</span>}
          </Box>
          <Box>
            {data.waiting === 0 && (
              <>
                {!!data.auth_required && (
                  <Button
                    icon="check-square"
                    color="red"
                    textAlign="center"
                    lineHeight="60px"
                    fluid
                    onClick={() => act('auth_swipe')}
                    content="授权"
                  />
                )}
                {data.auth_required === 0 && (
                  <>
                    <Button
                      icon="exclamation-triangle"
                      fluid
                      onClick={() => {
                        return act('red_alert');
                      }}
                      content="红色警报"
                    />
                    <Button
                      icon="id-card-o"
                      fluid
                      onClick={() => act('emergency_maint')}
                      content="应急维护通道权限"
                    />
                    {/* SKYRAT EDIT ADDITION START - Engineering Override */}
                    <Button
                      icon="wrench"
                      fluid
                      onClick={() => act('eng_override')}
                      content="工程超驰权限"
                    />
                    {/* SKYRAT EDIT ADDITION END */}
                    <Button
                      icon="meteor"
                      fluid
                      onClick={() => act('bsa_unlock')}
                      content="蓝空大炮解锁"
                    />
                    {/* SKYRAT EDIT ADDITION START - Permit Pins */}
                    {!!data.permit_pins && (
                      <Button
                        icon="key"
                        fluid
                        onClick={() => act('pin_unrestrict')}
                        content="许可证撞针取消开火限制"
                      />
                    )}
                    {/* SKYRAT EDIT ADDITION END */}
                    <Button
                      icon="key"
                      fluid
                      onClick={() => act('give_janitor_access')}
                      content="授予清洁工访问权限"
                    />
                  </>
                )}
              </>
            )}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
