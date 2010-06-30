nrsubj = 10;
nrsess = 3;

% data
for subj = 1:nrsubj
    for sess = 1:nrsess
        D(subj).raw(sess).premean = rand(30,1);
        D(subj).raw(sess).prermt = rand(3,1);
        D(subj).raw(sess).postmean = rand(30,1);
        D(subj).raw(sess).postrmt = rand(3,1);
        D(subj).raw(sess).postmean2 = rand(30,1);
        D(subj).raw(sess).ici = rand(20,1);
        D(subj).raw(sess).icf = rand(20,1);
    end
end
% preprocess
for subj = 1:nrsubj
    for sess = 1:nrsess
        D(subj).processed(sess).premean = h_cm(D(subj).raw(sess).premean);
        D(subj).processed(sess).postmean = h_cm(D(subj).raw(sess).postmean);
        D(subj).processed(sess).postmean2 = h_cm(D(subj).raw(sess).postmean2);
        D(subj).processed(sess).ici = h_cm(D(subj).raw(sess).ici);
        D(subj).processed(sess).icf = h_cm(D(subj).raw(sess).icf);
    end
end

str = {'pre(EA)','post','post2','pre(ES)','post','post2','pre(EK)','post','post2'};
for subj = 1:nrsubj
    Mp(subj,1) = D(subj).processed(1).premean.mean;
    Mp(subj,2) = D(subj).processed(1).postmean.mean;
    Mp(subj,3) = D(subj).processed(1).postmean2.mean;
    Mp(subj,4) = D(subj).processed(2).premean.mean;
    Mp(subj,5) = D(subj).processed(2).postmean.mean;
    Mp(subj,6) = D(subj).processed(2).postmean2.mean;
    Mp(subj,7) = D(subj).processed(3).premean.mean;
    Mp(subj,8) = D(subj).processed(3).postmean.mean;
    Mp(subj,9) = D(subj).processed(3).postmean2.mean;
    
    Sp(subj,1) = D(subj).processed(1).premean.std;
    Sp(subj,2) = D(subj).processed(1).postmean.std;
    Sp(subj,3) = D(subj).processed(1).postmean2.std;
    Sp(subj,4) = D(subj).processed(2).premean.std;
    Sp(subj,5) = D(subj).processed(2).postmean.std;
    Sp(subj,6) = D(subj).processed(2).postmean2.std;
    Sp(subj,7) = D(subj).processed(3).premean.std;
    Sp(subj,8) = D(subj).processed(3).postmean.std;
    Sp(subj,9) = D(subj).processed(3).postmean2.std;
    
    M(subj,1) = mean(D(subj).raw(1).premean);
    M(subj,2) = mean(D(subj).raw(1).postmean);
    M(subj,3) = mean(D(subj).raw(1).postmean2);
    M(subj,4) = mean(D(subj).raw(2).premean);
    M(subj,5) = mean(D(subj).raw(2).postmean);
    M(subj,6) = mean(D(subj).raw(2).postmean2);
    M(subj,7) = mean(D(subj).raw(3).premean);
    M(subj,8) = mean(D(subj).raw(3).postmean);
    M(subj,9) = mean(D(subj).raw(3).postmean2);
    
    S(subj,1) = std(D(subj).raw(1).premean);
    S(subj,2) = std(D(subj).raw(1).postmean);
    S(subj,3) = std(D(subj).raw(1).postmean2);
    S(subj,4) = std(D(subj).raw(2).premean);
    S(subj,5) = std(D(subj).raw(2).postmean);
    S(subj,6) = std(D(subj).raw(2).postmean2);
    S(subj,7) = std(D(subj).raw(3).premean);
    S(subj,8) = std(D(subj).raw(3).postmean);
    S(subj,9) = std(D(subj).raw(3).postmean2);
 end






