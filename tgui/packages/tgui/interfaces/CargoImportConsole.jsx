// THIS IS A SKYRAT UI FILE
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Divider, Image, Section, Stack } from '../components';
import { Window } from '../layouts';

export const CargoImportConsole = (props) => {
  const [category, setCategory] = useState('');
  const [weapon, setArmament] = useState('weapon');
  const { act, data } = useBackend();
  const {
    armaments_list = [],
    budget_points,
    budget_name,
    self_paid,
    cant_buy_restricted,
  } = data;
  return (
    <Window theme="armament" title="公司进口申请窗口" width={1000} height={600}>
      <Window.Content>
        <Section grow height="100%" title="公司进口申请窗口">
          <Stack>
            <Stack.Item grow fill>
              <Button.Checkbox
                content="私人购买"
                checked={self_paid}
                onClick={() => act('toggleprivate')}
              />
              <Box>
                <b>使用预算:</b> {budget_name}
              </Box>
              <Box>
                <b>剩余预算:</b> {budget_points}
              </Box>
            </Stack.Item>
          </Stack>
          <Divider />
          <Stack fill grow>
            <Stack.Item mr={1}>
              <Section title="公司目录">
                <Stack vertical>
                  {armaments_list.map((armament_category) => (
                    <Stack.Item key={armament_category.category}>
                      <Button
                        width="100%"
                        content={armament_category.category}
                        selected={category === armament_category.category}
                        onClick={() => setCategory(armament_category.category)}
                      />
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            </Stack.Item>
            <Divider vertical />
            <Stack.Item grow mr={1}>
              <Section title={category} scrollable fill height="480px">
                {armaments_list.map(
                  (armament_category) =>
                    armament_category.category === category &&
                    armament_category.subcategories.map((subcat) => (
                      <Section
                        key={subcat.subcategory}
                        title={subcat.subcategory}
                      >
                        <Stack vertical>
                          {subcat.items.map((item) => (
                            <Stack.Item key={item.ref}>
                              <Button
                                fontSize="15px"
                                textAlign="center"
                                selected={weapon === item.ref}
                                color={item.cant_purchase ? 'bad' : 'default'}
                                width="100%"
                                key={item.ref}
                                onClick={() => setArmament(item.ref)}
                              >
                                <Image
                                  src={`data:image/jpeg;base64,${item.icon}`}
                                  style={{
                                    'vertical-align': 'middle',
                                    'horizontal-align': 'middle',
                                  }}
                                />
                                &nbsp;{item.name}
                              </Button>
                            </Stack.Item>
                          ))}
                        </Stack>
                      </Section>
                    )),
                )}
              </Section>
            </Stack.Item>
            <Divider vertical />
            <Stack.Item width="20%">
              <Section title="已选择的物品">
                {armaments_list.map((armament_category) =>
                  armament_category.subcategories.map((subcat) =>
                    subcat.items.map(
                      (item) =>
                        item.ref === weapon && (
                          <Stack vertical key={item.ref}>
                            <Stack.Item>
                              <Image
                                src={`data:image/jpeg;base64,${item.icon}`}
                                height={'100%'}
                                width={'100%'}
                                style={{
                                  'vertical-align': 'middle',
                                  'horizontal-align': 'middle',
                                }}
                              />
                            </Stack.Item>
                            <Stack.Item>{item.description}</Stack.Item>
                            {!!cant_buy_restricted && !!item.restricted && (
                              <Stack.Item textColor={'red'}>
                                {'你无法通过此控制台购买限制物品!'}
                              </Stack.Item>
                            )}
                            <Stack.Item
                              textColor={
                                item.cost > budget_points ? 'red' : 'green'
                              }
                            >
                              {'花费: ' + item.cost}
                            </Stack.Item>
                            <Stack.Item>
                              <Button
                                content="购买"
                                textAlign="center"
                                width="100%"
                                disabled={
                                  item.cost > budget_points ||
                                  (!!cant_buy_restricted && !!item.restricted)
                                }
                                onClick={() =>
                                  act('equip_item', {
                                    armament_ref: item.ref,
                                  })
                                }
                              />
                            </Stack.Item>
                          </Stack>
                        ),
                    ),
                  ),
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
