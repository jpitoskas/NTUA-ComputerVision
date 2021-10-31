function  centr = min_dist (feat,centroids)

    all_dists = [];
    for j=1:size(centroids,1)
        temp_var = sum((feat - centroids(j,:)).^2);
        all_dists = [all_dists temp_var];
    end
    [~,centr] = min(all_dists);
end

