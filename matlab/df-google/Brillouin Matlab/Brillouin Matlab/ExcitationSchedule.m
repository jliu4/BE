heater_period = 40;
q_period      = 8;
t = (0:0.1:heater_period)'; % time in hours
q_power = 4*sin(pi*t/q_period).^2;
heater_power = 20*sin(pi*t/heater_period).^2;
figure
plot(t, [q_power, heater_power]);
xlabel('Time (hours)')
ylabel('Power (Watts)')
legend({'q-power', 'heater-power'})