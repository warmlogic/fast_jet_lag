function fast_jet_lag(destinationOriginTimeDiff,departureDayOfWeek,breakfastTimeDestination,fastHours)
% fast_jet_lag(destinationOriginTimeDiff,departureDayOfWeek,breakfastTimeDestination,fastHours)

% fast for about 12 or 16 hours before eating at the time of breakfast in
% the destination time zone
%
% http://harpers.org/blog/2012/03/the-empty-stomach-fasting-to-beat-jet-lag/
%
% e.g.,
% destinationOriginTimeDiff = 8;
% destinationOriginTimeDiff = -3;

% to do: use datestr(addtodate(datenum('07-June-2014 08:00:00'),12,'hour'))
% also use weekday()

if nargin < 4
  fastHours = [12 16];
  %fprintf('Using default fasting lengths %d to %d hours.\n',fastHours(1),fastHours(2));
  if nargin < 3
    breakfastTimeDestination = 8;
    fprintf('Using default breakfast time of %dam.\n',breakfastTimeDestination);
    if nargin < 2
      departureDayOfWeek = '';
      if nargin == 0
        error('Must at least supply the time difference between your origin and destination.');
      end
    end
  end
end

daysOfWeek = {'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'};

if isempty(departureDayOfWeek)
  departureDayOfWeek = '';
elseif ~isempty(departureDayOfWeek) && ~ischar(departureDayOfWeek)
  error('Day of week must be a string');
elseif ~isempty(departureDayOfWeek) && ischar(departureDayOfWeek)
  if sum(ismember(daysOfWeek,departureDayOfWeek)) == 0
    error('You entered ''%s'' for your departure day. Misspelled?',departureDayOfWeek);
  end
end

% set breakfast time in the destination as a string
btd_minutes = mod(breakfastTimeDestination,1) * 100;
btd_minutes = btd_minutes * 60;
btd_minutes = sprintf('%.2d',round(btd_minutes / 100));
if breakfastTimeDestination < 12
  meridian = 'am';
  breakfastTimeDestination_str = sprintf('%d:%s%s',floor(breakfastTimeDestination),btd_minutes,meridian);
elseif breakfastTimeDestination >= 12
  %warning('It is weird that breakfast in your destination is in the afternoon.');
  meridian = 'pm';
  if breakfastTimeDestination > 12
    breakfastTimeDestination_str = sprintf('%d:%s%s',floor(breakfastTimeDestination - 12),btd_minutes,meridian);
  else
    breakfastTimeDestination_str = sprintf('%d:%s%s',floor(breakfastTimeDestination),btd_minutes,meridian);
  end
end

% put the destination breakfast time in origin time zone
breakfastTimeOrigin = breakfastTimeDestination - destinationOriginTimeDiff;
if breakfastTimeOrigin < 0
  breakfastTimeOrigin = 24 + breakfastTimeOrigin;
end

bto_minutes = mod(breakfastTimeOrigin,1) * 100;
bto_minutes = bto_minutes * 60;
bto_minutes = sprintf('%.2d',round(bto_minutes / 100));
if breakfastTimeOrigin < 12
  meridian = 'am';
  if breakfastTimeOrigin == 0
    breakfastTimeOrigin_str = 'midnight';
  else
    breakfastTimeOrigin_str = sprintf('%d:%s%s',floor(breakfastTimeOrigin),bto_minutes,meridian);
  end
elseif breakfastTimeOrigin >= 12
  meridian = 'pm';
  if breakfastTimeOrigin == 12
    breakfastTimeOrigin_str = sprintf('%d:%s%s',floor(breakfastTimeOrigin),bto_minutes,meridian);
  else
    breakfastTimeOrigin_str = sprintf('%d:%s%s',floor(breakfastTimeOrigin - 12),bto_minutes,meridian);
  end
end

longFastBeginTime = breakfastTimeOrigin - fastHours(2);
if longFastBeginTime < 0
  longFastBeginTime = 24 + longFastBeginTime;
end

lfb_minutes = mod(longFastBeginTime,1) * 100;
lfb_minutes = lfb_minutes * 60;
lfb_minutes = sprintf('%.2d',round(lfb_minutes / 100));
if longFastBeginTime < 12
  meridian = 'am';
  longFastBeginTime_str = sprintf('%d:%s%s',floor(longFastBeginTime),lfb_minutes,meridian);
elseif longFastBeginTime >= 12
  meridian = 'pm';
  if longFastBeginTime > 12
    longFastBeginTime_str = sprintf('%d:%s%s',floor(longFastBeginTime - 12),lfb_minutes,meridian);
  else
    longFastBeginTime_str = sprintf('%d:%s%s',floor(longFastBeginTime),lfb_minutes,meridian);
  end
end

shortFastBeginTime = breakfastTimeOrigin - fastHours(1);
if shortFastBeginTime < 0
  shortFastBeginTime = 24 + shortFastBeginTime;
end

sfb_minutes = mod(shortFastBeginTime,1) * 100;
sfb_minutes = sfb_minutes * 60;
sfb_minutes = sprintf('%.2d',round(sfb_minutes / 100));
if shortFastBeginTime < 12
  meridian = 'am';
  shortFastBeginTime_str = sprintf('%d:%s%s',floor(shortFastBeginTime),sfb_minutes,meridian);
elseif shortFastBeginTime >= 12
  meridian = 'pm';
  if shortFastBeginTime > 12
    shortFastBeginTime_str = sprintf('%d:%s%s',floor(shortFastBeginTime - 12),sfb_minutes,meridian);
  else
    shortFastBeginTime_str = sprintf('%d:%s%s',floor(shortFastBeginTime),sfb_minutes,meridian);
  end
end

fprintf('If breakfast is at %s in your destination and the time difference is %.1f hours...\n',breakfastTimeDestination_str,destinationOriginTimeDiff);
fprintf('\tBegin fasting somewhere between %s and %s in the origin time zone, then eat a meal at %s in the origin time zone.\n',...
  longFastBeginTime_str,shortFastBeginTime_str,breakfastTimeOrigin_str);
